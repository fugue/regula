package topsort

import (
	"fmt"
	"strings"
)

type Key = string
type Graph = map[Key][]Key

// Simple topological sort for a string-based dependency graph.
func Topsort(original Graph) ([]Key, error) {
	sorted := []string{}
	done := map[Key]struct{}{}

	// Create working copy as we will mutate the graph.
	g := Graph{}
	for k, nbs := range original {
		g[k] = make([]Key, len(nbs))
		copy(g[k], nbs)
	}

	// Pop a random node.
	for curr := pop(g); curr != nil; curr = pop(g) {
		visited := map[Key]struct{}{}

		// Follow until no dependencies.
		next := curr
		for next != nil {
			curr = next

			// Check for cycles.
			if _, ok := visited[*curr]; ok {
				cycle := []string{}
				for k := range visited {
					cycle = append(cycle, k)
				}
				return nil, fmt.Errorf("Variables form a cycle: " + strings.Join(cycle, ", "))
			} else {
				visited[*curr] = struct{}{}
			}

			// Find a neighbor that isn't done.
			neighbors := g[*curr]
			next = nil
			for i := 0; i < len(neighbors) && next == nil; {
				k := neighbors[i]
				if _, exists := g[k]; !exists {
					// Trim in-place if not exists to make subsequent runs fast.
					neighbors = append(neighbors[:i], neighbors[i+1:]...)
					g[*curr] = neighbors
				} else if _, isDone := done[k]; !isDone {
					// Found an element that's not done.
					curr = next
					next = &k
				} else {
					// Try next neighbor.
					i += 1
				}
			}
		}

		// Add to sorted once we're done and remove from the graph.
		sorted = append(sorted, *curr)
		done[*curr] = struct{}{}
		delete(g, *curr)
	}

	return sorted, nil
}

// Pops a random key from a graph
func pop(g Graph) *Key {
	for k := range g {
		return &k
	}
	return nil
}
