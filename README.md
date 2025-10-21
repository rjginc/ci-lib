# RJG Nix CI library

Home of RJG, Inc. shared nix functions.

## Contributing

We use the official formatter: [nixfmt](https://github.com/NixOS/nixfmt?tab=readme-ov-file).

- Run `nix fmt`.

Please ask someone for help if you are unable to run nixfmt.

## Usage

To add it to another project, follow these steps:

1. In your project, edit `flake.nix` and add an input for this repo near the top, below the other inputs.
2. Then assign a `follows` that maps to the name of your existing instance of `nixpkgs`.

```nix
   inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
+  inputs.ci-lib.url = "github:rjginc/ci-lib";
+  inputs.ci-lib.inputs.nixpkgs.follows = "nixpkgs";
```

3. Add the new input to your outputs.
   - The exact syntax will vary, because there are multiple ways to structure `outputs` in a flake file.

```nix
-  outputs = { self, nixpkgs }:
+  outputs = { self, nixpkgs, ci-lib }:
```

4. Add this project's default overlay to your project.
   - The exact syntax will vary, because there are multiple ways to instantiate `nixpkgs`.

```nix
-        pkgs = import nixpkgs { inherit system; overlays = [ ]; };
+        pkgs = import nixpkgs { inherit system; overlays = [ ci-lib.overlays.default ]; };
```

5. Then you will have access to the functions from this library.
   - For example, `pkgs.lib.getDebianVersion`

### Interact in nix repl

The REPL is useful for exploration. To load this project and interact with it in the nix repl, do this:

1. In a terminal at the root of this repository, launch the REPL
   - `nix repl`
   1. Inside the repl, input the command to load this repo as a flake
      - `:lf .`
   2. Then wire up the overlay: 
      - `pkgs = import inputs.nixpkgs { overlays = [ outputs.overlays.default ]; }`
   3. Now you can use the library functions in this repo
      - Try this: `pkgs.lib.getDebianVersion "1.2.3"`
