# Fix: bash highlighting doesn't work as of this commit:
# https://github.com/NixOS/nixpkgs/commit/49cce41b7c5f6b88570a482355d9655ca19c1029

inputs: _final: prev: {
  tree-sitter-grammars = prev.tree-sitter-grammars // {
    tree-sitter-bash = prev.tree-sitter-grammars.tree-sitter-bash.overrideAttrs
      (old: {
        src = prev.fetchFromGitHub {
          owner = "tree-sitter";
          repo = "tree-sitter-bash";
          rev = "493646764e7ad61ce63ce3b8c59ebeb37f71b841";
          sha256 = "sha256-gl5F3IeZa2VqyH/qFj8ey2pRbGq4X8DL5wiyvRrH56U=";
        };
      });
    tree-sitter-ini = prev.tree-sitter.buildGrammar {
      language = "ini";
      version = "1.0.0";
      src = prev.fetchFromGitHub {
        owner = "justinmk";
        repo = "tree-sitter-ini";
        rev = "1a0ce072ebf3afac7d5603d9a95bb7c9a6709b44";
        sha256 = "sha256-pPtKokpTgjoNzPW4dRkOnyzBBJFeJj3+CW3LbHSKsmU=";
      };
    };
    tree-sitter-puppet = prev.tree-sitter.buildGrammar {
      language = "puppet";
      version = "1.0.0";
      src = prev.fetchFromGitHub {
        owner = "amaanq";
        repo = "tree-sitter-puppet";
        rev = "v1.0.0";
        sha256 = "sha256-vk5VJZ9zW2bBuc+DM+fwFyhM1htZGeLlmkjMAH66jBA=";
      };
    };
    tree-sitter-rasi = prev.tree-sitter.buildGrammar {
      language = "rasi";
      version = "0.1.1";
      src = prev.fetchFromGitHub {
        owner = "Fymyte";
        repo = "tree-sitter-rasi";
        rev = "371dac6bcce0df5566c1cfebde69d90ecbeefd2d";
        sha256 = "sha256-2nYZoLcrxxxiOJEySwHUm93lzMg8mU+V7LIP63ntFdA=";
      };
    };
  };

}