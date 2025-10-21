let
  lexicalPrefixMap = {
    testing = "0";
    uat = "1";
    alpha = "2";
  };
in
/**
  Compute a Debian version string from an RJG version string.

  The RJG-format for ReleasesV2 is described in our wiki. (Search for "Naming Conventions")

  This function gives a version string with a total ordering in Debian tooling, where the public release (e.g. '1.2.3') is always greater than the internal release versions (e.g. '1.2.3~2~alpha.1-1'). This function matches the `formatDebVersion` method in our Jenkins shared library.

  The Debian version is documented at [Debian Version Policy](https://www.debian.org/doc/debian-policy/ch-controlfields.html#version). Briefly, it is this format:

  - `[epoch:]upstream_version[-debian_revision]` and we use this with the following constraints:
     - hardcode 'debian_revision' fragment to 1
     - leave out 'epoch' so it defaults to 0

  # Inputs
  `full_version`
  : The RJG-format releasesV2 full version string.

  # Type
  ```
  getDebianVersion :: string -> string
  ```

  # Examples
  :::{.example}
  ## `lib.getDebianVersion` usage example

  ```nix
  getDebianVersion "7.0.0-testing-round-1"
  => "7.0.0~0~testing.1-1"

  getDebianVersion "7.0.0-uat-round-1"
  => "7.0.0~1~uat.1-1"

  getDebianVersion "7.0.0-alpha-round-1"
  => "7.0.0~2~alpha.1-1"

  getDebianVersion "7.0.0-alpha-round-2"
  => "7.0.0~2~alpha.2-1"

  getDebianVersion "7.0.0-alpha-round-3"
  => "7.0.0~2~alpha.3-1"

  getDebianVersion "7.0.0"
  => "7.0.0-1"

  ```

  :::
*/
fullVersion:
if builtins.length (builtins.split "-" fullVersion) == 1 then
  fullVersion + "-1"
else
  let
    splits = builtins.split "-" fullVersion;
    version = builtins.elemAt splits 0;
    channel = builtins.elemAt splits 2;
    round = builtins.elemAt splits 6;
  in
  version + "~" + "${lexicalPrefixMap.${channel}}" + "~" + channel + "." + round + "-1"
