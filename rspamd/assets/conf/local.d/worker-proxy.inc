milter = yes; # Enable milter mode
timeout = 120s; # Needed for Milter usually
upstream "local" {
    default = yes; # Self-scan upstreams are always default
    self_scan = yes; # Enable self-scan
}