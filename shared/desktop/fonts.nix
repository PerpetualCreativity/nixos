{ pkgs, ... }:
{
  nixpkgs.config = {
    packageOverrides = super: let self = super.pkgs; in {
      iosevka-term = self.iosevka.override {
        set = "-fire-sans-term";

        privateBuildPlan = {
          family = "Iosevka Fire Sans";
          spacing = "term";
          serifs = "sans";
          noCvSs = true;
          exportGlyphNames = true;

          ligations.inherits = "dlig";

          variants.design = {
            capital-g = "toothless-corner-serifless-hooked";
            capital-n = "asymmetric-serifless";
            capital-q = "open-swash";
            capital-v = "curly-serifless";
            capital-w = "curly-serifless";
            capital-x = "curly-serifless";
            capital-z = "curly-serifless-with-crossbar";
            f = "tailed";
            k = "curly-serifless" ;
            v = "curly-serifless";
            w = "curly-serifless";
            x = "semi-chancery-curly-serifless";
            z = "curly-serifless-with-crossbar";
            lower-delta = "flat-top";
            zero = "dotted";
            three = "flat-top-serifless";
            five = "upright-flat-serifless";
            seven = "bend-serifless-crossbar";
            punctuation-dot = "round";
            tilde = "low";
            asterisk = "hex-low";
            ascii-single-quote = "straight";
            paren = "flat-arc";
            brace = "straight";
            number-sign = "slanted-open";
            ampersand = "lower-open";
            at = "threefold-tall";
            dollar = "interrupted";
            cent = "open";
            percent = "dots";
            bar = "natural-slope";
            question = "corner-flat-hooked";
            pilcrow = "low";
            lig-ltgteq = "slanted";
            lig-neq = "slightly-slanted";
            lig-equal-chain = "with-notch";
            lig-hyphen-chain = "with-notch";
            lig-plus-chain = "with-notch";
            lig-double-arrow-bar = "with-notch";
            lig-single-arrow-bar = "with-notch";
          };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    iosevka-term
  ];
}
