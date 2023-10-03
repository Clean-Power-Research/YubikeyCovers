include <roundedcube.scad>;

wallthickness = 2;
gap = 4;
thumbgapRadius = 10;
keyHoleRadius = 1.5;
initials = "RO";
initialsFontSize = 6;
font = "Gill Sans";
width=47.5;
length = 22;
holdblocklength=12;
keyHoleX = 5;
keyHoleY = 12;
innerRingHeight=1;

module innerRing()
{
    linear_extrude(innerRingHeight)
        difference()
        {
            circle(keyHoleRadius +1, $fn = 30);
            circle(keyHoleRadius, $fn = 30);
        };    
}

union()
{    
    difference()
    {
        // cube with rounded edge as outer perimeter
        roundedcube_simple([width, length, 2* wallthickness + gap], radius=1);
        
        // cut out gap to key
        translate([-wallthickness, 2, wallthickness])
            cube([width, length, gap], center=false);

        // cut out gap to pull key out
        translate([width/2,-thumbgapRadius/6,-1])
            linear_extrude(2*wallthickness + gap + 2)
                circle(thumbgapRadius);
        
        // cut hole for key ring
        translate([keyHoleX, keyHoleY,-1])
            linear_extrude(2*wallthickness + gap + 2)
                circle(keyHoleRadius, $fn = 30);
        
        // add CPR logo
        translate([width+8,4, 0])
            rotate([0,0,90])
            linear_extrude(wallthickness/2)
                resize([0,15,0], auto=true)
                    import(file = "CPR Logo Only.svg");                
        
        // add initials
        translate([40, 5, 1.5*wallthickness + gap])
            rotate([0,0,90])
            linear_extrude(wallthickness/2)
            text(
                text = initials, 
                size = initialsFontSize, 
                font = font, 
                valign = "center", 
                halign = "left",
                $fn = 50
        );            
    };
    
    // massive bottom plate, just to try out when filament actually sticks
    *translate([width/2,length+wallthickness-1,gap/2])
        rotate([90,0,0])
        linear_extrude(2)
        circle(d=width+2*wallthickness);
    

    // add stop block
    translate([width-holdblocklength-wallthickness, wallthickness, wallthickness])
        cube([holdblocklength, 3, gap], center=false);
    
    // add block to hold better in place
    translate([width-holdblocklength-wallthickness, length-3, wallthickness])
        cube([holdblocklength, 3, gap/2-0.5], center=false);
    
    // add inner ring to key hole
    translate([keyHoleX, keyHoleY, wallthickness])
        innerRing();
    translate([keyHoleX, keyHoleY, wallthickness+gap-innerRingHeight])
        innerRing();
                

}