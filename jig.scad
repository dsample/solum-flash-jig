//!OpenSCAD
$fn = 200;

module makePinTopper(pinD, pinHeadD) {
  union(){
    cylinder(r1=(pinD / 2), r2=(pinD / 2), h=4, center=false);
    translate([0, 0, 0]){
      cylinder(r1=(pinHeadD / 2), r2=(pinHeadD / 2), h=0.5, center=false);
    }
  }
}

module makePin(pinD, pinHeadD) {
  union(){
    cylinder(r1=(pinD / 2), r2=(pinD / 2), h=4, center=false);
    translate([0, 0, 3.5]){
      cylinder(r1=(pinHeadD / 2), r2=(pinHeadD / 2), h=0.5, center=false);
    }
  }
}

module makeCentredPinTopper(padW, padH, pinDia, pinHeadDia) {
  union(){
    translate([(padW / 2), (padH / 2), 0]){
      makePinTopper(pinDia, pinHeadDia);
    }
  }
}

module makePadWithPin(padW, padH, pinDia, pinHeadDia) {
  union(){
    translate([(padW / 2), (padH / 2), 0]){
      makePin(pinDia, pinHeadDia);
    }
  }
}

module makeProbeBlock(L, W, Radius, H) {
  color([1,0.8,0]) {
    hull(){
      translate([Radius, Radius, 0]){
        cylinder(r1=Radius, r2=Radius, h=H, center=false);
      }
      translate([(W - Radius), Radius, 0]){
        cylinder(r1=Radius, r2=Radius, h=H, center=false);
      }
      translate([(W - Radius), (L - Radius), 0]){
        cylinder(r1=Radius, r2=Radius, h=H, center=false);
      }
      translate([Radius, (L - Radius), 0]){
        cylinder(r1=Radius, r2=Radius, h=H, center=false);
      }
    }
  }
}

pinDiameter = 0.86;
pinHeadDiameter = 1;
padWidth = 1.5;
padHeight = 1.5;
pinSpacing = 1.75;
topBorder = 1;
leftBorder = 1;

difference() {
  union(){
    makeProbeBlock(6.5, 9, 0.2, 4);
    difference() {
      translate([-0.5, -0.5, 3]){
        makeProbeBlock(7.5, 10, 0.5, 3);
      }

      translate([0.5, 0.5, 3]){
        makeProbeBlock(5.5, 8, 0.2, 4);
      }
    }
  }

  for (row = [1 : abs(1) : 3]) {
    if (row % 2 == 1) {
      translate([leftBorder, 0, 0]){
        for (pin = [0 : abs(1) : 3]) {
          if (!(row == 3 && pin == 2)) {
            translate([(pin * pinSpacing), (topBorder + (row - 1) * pinSpacing), 0]){
              makePadWithPin(padWidth, padHeight, pinDiameter, pinHeadDiameter);
            }
          }

        }

      }
    } else {
      for (pin = [0 : abs(1) : 1]) {
        translate([((leftBorder + pinSpacing / 2) + pin * pinSpacing), (topBorder + pinSpacing), 0]){
          makePadWithPin(padWidth, padHeight, pinDiameter, pinHeadDiameter);
        }
      }

    }

  }

}
translate([0, 0, 2]){
  rotate([0, 180, 0]){
    translate([0, 15, 0]){
      color([0.2,0.2,1]) {
        difference() {
          makeProbeBlock(5.48, 7.98, 0.2, 2);

          union(){
            translate([0, (5.48 / 2), 0]){
              cylinder(r1=1.25, r2=1, h=10, center=false);
            }
            translate([7.98, (5.48 / 2), 0]){
              cylinder(r1=1.25, r2=1, h=10, center=false);
            }
            for (row = [1 : abs(1) : 3]) {
              if (row % 2 == 1) {
                translate([0.51, 0, 0]){
                  for (pin = [0 : abs(1) : 3]) {
                    if (!(row == 3 && pin == 2)) {
                      translate([(pin * pinSpacing), (0.5 + (row - 1) * pinSpacing), 0]){
                        makeCentredPinTopper(padWidth, padHeight, pinDiameter, pinHeadDiameter);
                      }
                    }

                  }

                }
              } else {
                for (pin = [0 : abs(1) : 1]) {
                  translate([((0.5 + pinSpacing / 2) + pin * pinSpacing), (0.5 + pinSpacing), 0]){
                    makeCentredPinTopper(padWidth, padHeight, pinDiameter, pinHeadDiameter);
                  }
                }

              }

            }

          }
        }
      }
    }
  }
}
translate([0.51, 0.51, 4]){
}