# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "valv"

require "minitest/autorun"

module TestFixtures
  PRIVATE_KEY = "LupoKAFUrJGJGSxOQEH9jSNx4N29oEfkbRiWXsn15QE="
  PUBLIC_KEY = "cUBo9LUaIdqBlL0ZoE9nrslf89zrXUTE6vEbiZOKp2Q="

  OTHER_PRIVATE_KEY = "j6j8wbg1rZqtyr9Om/kcpoi370HOKpzifMoXfY/yVcE="
  OTHER_PUBLIC_KEY = "D4J2whCyTA2DN7QKWdosZwWYn300Z3jWnW6Gt2HVHyM="
end
