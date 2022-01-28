package filesystems

type VirtualFs interface {
	RealPath(name string) string
}
