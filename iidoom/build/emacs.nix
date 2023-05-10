with (import <nixpkgs> {});

(emacs-nox.override {
     nativeComp = true;
}).overrideAttrs (old : {
     pname = "emacs";
     version = "head";
     src = fetchFromGitHub {
        owner = "emacs-mirror";
        repo = "emacs";
        rev = "7791907c3852e6ec197352e1c3d3dd8487cc04f5";
        sha256 = "sha256-O5Tp+6Uz+7FejRIfJx6bgXBEuxoeyyKdpDqRdMuzjZU=";
     };
     patches = [];
     configureFlags = old.configureFlags ++ ["--with-json"];
     preConfigure = "./autogen.sh";
     buildInputs = old.buildInputs ++ [ autoconf texinfo ];
})
