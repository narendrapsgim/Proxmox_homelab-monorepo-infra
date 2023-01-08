include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../module"
}

inputs = {
  bucket = "loki"
  bucket_ilm_policy = [
    {
      id         = "expire-31d"
      expiration = "31d"
      filter     = "fake/"
    }
  ]
}
