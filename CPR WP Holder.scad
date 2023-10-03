include <roundedcube.scad>;

wallthickness = 2;
gap = 4;
thumbgapRadius = 10;
keyHoleRadius = 1.5;
font = "Gill Sans";
width=47.5;
length = 22;
holdblocklength=12;
keyHoleX = 5;
keyHoleY = 12;
innerRingHeight=1;
mode = "both";

module innerRing()
{
    linear_extrude(innerRingHeight)
        difference()
        {
            circle(keyHoleRadius + 0.5, $fn = 30);
            circle(keyHoleRadius, $fn = 30);
        };    
}

module logos()
{
    // add CPR logo
    translate([width+8,4, 0])
        rotate([0,0,90])
        linear_extrude(wallthickness/2)
            resize([0,15,0], auto=true)
                import(file = "CPR Logo Only.svg");                
    
    // add WattPlan logo
    /*translate([width+3,5, gap + 1.5 * wallthickness])
        rotate([0,0,90])
        linear_extrude(wallthickness/2)
            resize([0,12,0], auto=true)
                import(file = "../wattplan-logo-only.svg"); */
                
/*    // can't figure out how to do it in SVG - draw circle around it manually        
    translate([width - 10,12, gap + 1.5 * wallthickness])
        rotate([0,0,90])
        linear_extrude(wallthickness/2)
        difference()
        {
            circle(d=15); 
            circle(d=13);
        }*/
}
if (mode == "logoonly")
{
    logos();
}
else
{
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
            
            logos();
        };
        
        // add stop block
        translate([width-holdblocklength-wallthickness, wallthickness, wallthickness])
            cube([holdblocklength, 3, gap], center=false);
        
        // add block to hold better in place
        translate([width-holdblocklength-wallthickness, length-3, wallthickness])
            cube([holdblocklength, 3, gap/2-0.75], center=false);
        
        // add inner ring to key hole
        translate([keyHoleX, keyHoleY, wallthickness])
            innerRing();
        translate([keyHoleX, keyHoleY, wallthickness+gap-innerRingHeight])
            innerRing();
    }
}