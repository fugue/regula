# regulatf

This package supports loading HCL configurations.  Since it is a bit more
complex than the other loaders, it has it's own package.  What follows is
a brief but complete overview of how it works.

It tries to mimic terraform behavior as much as possible by using terraform
as a library.  Since some packages inside terraform are in an `/internal`
package, we vendor in terraform and rename the packages to make them
accessible from our code.  This is automated in the top-level Makefile.

## names.go

[names.go] holds some utilities to work with names, for example parsing them
from strings and rendering them back to strings.  A name consists of two parts:

 -  A module part (e.g. `module.child1.`).  This is empty for the root module.
 -  A local part (e.g. `aws_s3_bucket.my_bucket` or `var.my_var`).  This local
    part can refer to arbitrarly deeply nested expressions, e.g.
    `aws_security_group.invalid_sg_1.ingress[0].from_port`.

Importantly, there are a number of `AsXYZ()` methods, for example
`AsModuleOutput()`.  These manipulate the names to point to their "real"
location: for example, if you use `module.child1.my_output` in the root
module, the "real" location is the output inside the child module, so
`module.child1.outputs.my_output`.  These methods form a big part of the logic
and having it here allows us to keep the code in other files relatively clean.

## moduletree.go

[moduletree.go] is responsible for parsing a directory of terraform files,
including children (submodules).  We end up with a hierarchical structure:

 -  root module
     *  child 1
     *  child 2
         -  grandchild

We can "walk" this tree using a visitor pattern.  This visits every expression
in every nested submodule, for example:

  -  `aws_security_group.invalid_sg_1.ingress[1].from_port` = `22`
  -  `module.child1.some_bucket.bucket_prefix` = `"foo"`

Because we pass in both the full name (see above) as well as the expression,
a visitor can store these in a flat rather than hierarchical map, which is
more convenient to work with in Go.

This file uses an additional file [moduleregister.go] to deal with the locations
of remote (downloaded) terraform modules.

## valtree.go

A bit of an implementation detail, but worth discussing anyway, [valtree.go] is
how we will store the values of these expressions once they have been evaluated.
The terraform internals use `cty.Value` for this, but this does not suffice for
our use case, since `cty.Value` is immutable.  If we want to evaluate HCL in an
iterative way, we would need to deconstruct and reconstruct these large values
(representing the entire state) at every step.

So you can think of `ValTree` as a _mutable_ version of `cty.Value`.  We also
use names for lookup and construction, which makes them even more convenient.
We can build sparse or dense value trees and then "merge" them together; this
is used heavily during evaluation.

As an example, these two expressions:

  -  `aws_security_group.invalid_sg_1.ingress[1].from_port` = `22`
  -  `module.child1.some_bucket.bucket_prefix` = `"foo"`

Would eventually, during evaluation, result in the following sparse `ValTree`:

```
{
  "aws_security_group": {
    "invalid_sg_1": {
      "ingress": {
        1: {
          "from_port": 22
        }
      }
    }
  },
  "module": {
    "child1": {
      "some_bucket": {
        "bucket_prefix": "foo"
      }
    }
  }
}
```

## regulatf.go

Finally, using these foundations, [regulatf.go] implements the main logic.
This happens in the following imperative steps:

1.  We use the visitor from [moduletree.go] to obtain a full list of everything
    in the module and its children.

2.  For every expression, we can compute its dependencies (possibly renaming
    some using the logic in [names.go]).  This gives us enough info to run a
    [topological sort](https://en.wikipedia.org/wiki/Topological_sorting);
    which tells us the exact order in which all expressions should be evaluated.

3.  We run through and evaluate each expression.

     -  We have a single big `ValTree` that holds **everything** we have
        evaluated so far.

     -  For performance reasons, construct a sparse `ValTree` with only the
        exact dependencies of the expression, and pass this in as scope.

     -  After evaluating, we build a sparse `ValTree` containing only the
        result of this expression, and merge that back into the big `ValTree`.

4.  We convert the big `ValTree` into the resources view (this involves only
    some minor bookkeeping like adding the `id` and `_provider` fields).

[moduleregister.go]: moduleregister.go
[moduletree.go]: moduletree.go
[names.go]: names.go
[regulatf.go]: regulatf.go
[valtree.go]: valtree.go
