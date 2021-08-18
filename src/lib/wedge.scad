outerboxsize = 45.65;
outerboxwall= 4;
outerboxheight = 10.5;

wedgelength=45;
wedgeheight=10;

wedgeadjust = 12.9;

//M8 - too big for this small project
//screwd=8;
//nutd=14.8;
//nuth=6.5;

//M4 
screwd=4.1;
nutd=7.9;
nuth=3.25;

boxplay=(outerboxsize-wedgelength)/2;

m=-outerboxwall-boxplay;
//translate([m,m,m])
//    outerbox();


//translate([0,0,-wedgeadjust/2])
//    railadapter();

//translate([0,-wedgelength/4,0])
//    wedgeliftrounded();

//screwcylinder();
//travelnut();

module outerbox() {
    ob = outerboxsize + 2*outerboxwall;
    difference() {
        cube([ob,ob,outerboxheight]);
        translate([outerboxwall,outerboxwall,outerboxwall])
            cube([outerboxsize,outerboxsize,outerboxheight]);
        
        translate([outerboxwall+boxplay,outerboxwall+boxplay,0]) {
            mountholes();
            translate([0,0,.5]) mountholes(d=10);
            
            /*
            translate([4+5/2+boxplay,3+5/2+boxplay,-1])
                cylinder(h=outerboxheight,d=5,$fn=60);
            translate([4+5/2+boxplay,45-3-5/2-boxplay,-1])
                cylinder(h=outerboxheight,d=5,$fn=60);
            translate([45-4-5/2-boxplay,45-3-5/2-boxplay,-1])
                cylinder(h=outerboxheight,d=5,$fn=60);
            translate([45-4-5/2-boxplay,3+5/2+boxplay,-1])
                cylinder(h=outerboxheight,d=5,$fn=60);
            */
            
            //translate([outerboxwall+outerboxsize,outerboxwall,-1])
            //    cylinder(h=outerboxheight,d=5,$fn=60);
            //translate([outerboxwall+outerboxsize,outerboxwall+outerboxsize,-1])
            //    cylinder(h=outerboxheight,d=5,$fn=60);
            //translate([outerboxwall,outerboxwall+outerboxsize,-1])
            //    cylinder(h=outerboxheight,d=5,$fn=60);                
        }
        
        
        //cutting out corners to make sure the insert part slides ok
        /*translate([outerboxwall,outerboxwall,outerboxwall/2])
            cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
        translate([outerboxwall+outerboxsize,outerboxwall,outerboxwall/2])
            cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
        translate([outerboxwall+outerboxsize,outerboxwall+outerboxsize,outerboxwall/2])
            cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
        translate([outerboxwall,outerboxwall+outerboxsize,outerboxwall/2])
            cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
        */
        translate([outerboxwall+boxplay,0,outerboxwall])screwcylinder();
    }
}

module mountholes(d=5.5) {
    translate([6.5,7.5,0])
        cylinder(h=outerboxheight,d=d,$fn=60);
    translate([6.5,37.5,0])
        cylinder(h=outerboxheight,d=d,$fn=60);
    translate([38.5,37.5,0])
        cylinder(h=outerboxheight,d=d,$fn=60);
    translate([38.5,7.5,0])
        cylinder(h=outerboxheight,d=d,$fn=60);
}



module boxholes() {
    translate([outerboxwall,outerboxwall,1])
                cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
            translate([wedgelength-outerboxwall/4,wedgelength/2+outerboxwall/4,0])
                cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
            translate([wedgelength-outerboxwall/4,wedgelength-outerboxwall/4,0])
                cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
            translate([outerboxwall/4,wedgelength-outerboxwall/4,0])
                cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
}


module railadapter() {
    difference() {
        rotate ([90,0,0])
            import("Linear_Rail_Adapter_v3.stl");
        hull() {
            wedge();
            translate([0,0,wedgeadjust/2]) wedge(); //the adjustable part of the height
        }
        hull() {
            translate([0,0,-wedgeheight])screwcylinder();
            translate([0,0,wedgeadjust/2])screwcylinder();
        }
        mountholes();
    }
}


module wedge() {
    mirror([0,0,1])
        rotate([0,90,0])
        linear_extrude(height=wedgelength)
        polygon(points=[[0,0],[0, wedgelength],[wedgeheight,wedgelength]]);
}


module wedgelift() {
    difference() {
        wedge();
        cube([wedgelength,wedgelength/2,wedgelength]);
        screwcylinder();
        hull() {
            translate([0,0,wedgeheight])travelnut();
            travelnut();
        }
    }
}

module wedgeliftrounded() {
    intersection() {
        wedgelift();
        hull() {
            translate([0,wedgelength*0.95,wedgeheight/2])
                rotate([0,90,0])
                cylinder(wedgelength,d=wedgeheight,$fn=60);
            translate([0,(wedgelength/2)*1.1,wedgeheight/2/2])
                rotate([0,90,0])
                cylinder(wedgelength,d=(wedgeheight/2)*1.2,$fn=60);
        }
        hull() {
            translate([outerboxwall/4,wedgelength/2+outerboxwall/4,0])
                cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
            translate([wedgelength-outerboxwall/4,wedgelength/2+outerboxwall/4,0])
                cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
            translate([wedgelength-outerboxwall/4,wedgelength-outerboxwall/4,0])
                cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
            translate([outerboxwall/4,wedgelength-outerboxwall/4,0])
                cylinder(h=outerboxheight,d=outerboxwall/2,$fn=60);
        }
    }
    
}


module screwcylinder() {
    translate([wedgelength/2,-wedgelength/2,2+screwd/2])
        rotate([-90,0,0])
        cylinder(h=wedgelength*2,d=screwd, $fn=60);
    
}

module travelnut() {
    translate([wedgelength/2,wedgelength*4/5,2+screwd/2])
        rotate([-90,360/12,0])
        //rotate([-90,0,0])
        cylinder(h=nuth,d=nutd,$fn=6);
}


//attempting new approach

bottomh=5;   //probably a bit too high, reduced to 4, but done in slicer
bottoms = 45;
wedgeh=8;
wedgeb=13;
wedgediff=2;

//bottomwedge();
//translate([0,-bottoms/2,wedgeh/2])
//railadapterbis();

/*difference() {

    slider(t="internal");
    slider(t="external");
}*/
        
    

module bottomwedge() {
    difference() {
        union() {
            difference() {
                cube([bottoms,bottoms,bottomh]);
                mountholes();
                translate([0,0,2]) mountholes(d=10);
            }
            slider();
        }
        rot = asin((wedgeh)/bottoms);
        hull() intersection() {
            union() {
                rotate([rot,0,0]) screwcylinderbis();
                screwcylinderbis();
            }
            cube(bottoms);
        }
        cube([bottoms,bottoms,1]);
    }
    
}

module slider(t="external") {
    //to add to it
    play=t=="internal" ? 0.25 : 0;
    
    l = bottoms*2;
    rot = asin((wedgeh)/bottoms);
    intersection() {
        //translate([bottoms/2-wedgeb/2,0,-(wedgeh)])
            translate([bottoms/2-wedgeb/2,0,0])
            rotate([-rot,0,0])
            
            rotate([90,0,0])
            translate([0,0,-bottoms])
            linear_extrude(height=l)
            polygon(points=[[wedgediff-play,0],[wedgeb-wedgediff+play, 0],[wedgeb+play,wedgeh+bottomh+play],[0-play,wedgeh+bottomh+play]]);
        
        cube(bottoms);
    }
}

module railadapterbis() {
    difference() {
        rotate ([90,0,0])
            import("Linear_Rail_Adapter_v3.stl");
        rot = asin((wedgeh)/bottoms);
        //not really sure about the part below, the 2.5 is a bit of a magic number, but good enough. Sick of trying to understand it completely :p
        translate([0,bottoms,wedgeh*2+2.5])
        mirror([0,1,0])
        mirror([0,0,1])
        hull() intersection() {
            union() {
                rotate([rot,0,0]) screwcylinderbis();
                screwcylinderbis();
            }
            cube(bottoms);
        }
        cube([bottoms,bottoms,bottomh]);
        slider(t="internal");
        mountholes();
        translate([0,0,10]) mountholes();
    }
    
    /*
    rot = asin((wedgeh)/bottoms);
        translate([0,bottoms,wedgeh*2])
        mirror([0,1,0])
        mirror([0,0,1])
        hull() intersection() {
            union() {
                rotate([rot,0,0]) screwcylinderbis();
                screwcylinderbis();
            }
            cube(bottoms);
        }
        
    */

}

module screwcylinderbis() {
    hull() {
            translate([0,0,wedgeh-screwd/2-5]) screwcylinderhelper();
            translate([0,0,0])screwcylinderhelper();
        }
}

module screwcylinderhelper() {
        translate([bottoms/2,-bottoms/2,bottomh+screwd/2+1])
        rotate([-90,0,0])
        cylinder(h=bottoms*2,d=screwd, $fn=60);
}






/**
 * third and final iteration
 **/

//https://github.com/adrianschlatter/threadlib
use <threadlib/threadlib.scad>

outerd=26;
innerd=21;
tubed=outerd+4;
baseh=1;
tolerance=0.4;
th=6; //thread height
ringgriph=1.5;
thread="M18x1.5";
threadp=1.5;

//assembly();

//bottomwiththread();
//railtopwithhole();
//threadedtube();
//bottomfiller();

//wrench();

module assembly() {
    difference() {
        union() {
            bottomwiththread();
            translate([0,0,-3.25]) railtopwithhole();
            translate([bottoms/2,bottoms/2,baseh]) threadedtube();
            mirror([0,0,1]) bottomfiller();
        }
        translate([bottoms/2,bottoms/2,0]) cube([bottoms,bottoms,bottoms]);
    }
}

module bottomwiththread() {
    difference() {
        union() {            
            difference() {
                cube([bottoms,bottoms,baseh]);
                mountholes();
                translate([0,0,2]) mountholes(d=10);
                translate([bottoms/2,bottoms/2,1]) threadbasecutout();
            }
            translate([bottoms/2,bottoms/2,baseh]) bolt(thread, turns=(th/threadp)-1);
        }
        translate([bottoms/2,bottoms/2,0])
            cylinder(h=baseh+th*2,d=8); //cutout for adjustment screw of the bearing
    }    
}

module bottomfiller() {
    difference() {
        union() {
            cube([bottoms,bottoms,baseh]);
            translate([(bottoms-18)/2,0,1]) cube([18,bottoms,1]);
        }
        mountholes();
        translate([bottoms/2,bottoms/2,0])
            cylinder(h=baseh+th*2,d=8); //cutout for adjustment screw of the bearing
    }
}


module railtopwithhole() {
    cuth=10.5;
    dia = 14;
    difference() {
        rotate ([90,0,0])
            import("Linear_Rail_Adapter_v3.stl");
        translate([0,0,10.5]) mountholes();
        cube([bottoms,bottoms,10.5]);
        translate([bottoms/2,bottoms/2,10.5]) circlesupportcutout();
        //for debugging purposes
        //translate([bottoms/2,bottoms/2,10]) cube([bottoms,bottoms,11]);
        hull() {
            translate([dia/2,dia/2+1,0]) cylinder(h=30,d=dia);
            translate([dia/2,0,0]) cylinder(h=30,d=dia);
            translate([0,dia/2+1,0]) cylinder(h=30,d=dia);
        }
    }
}

module circlesupportcutout() {
    difference() {
        cylinder(h=ringgriph,d=outerd+tolerance/2, $fn=60);
        cylinder(h=ringgriph,d=innerd-tolerance/2, $fn=60);
    }
}


module threadbasecutout() {
    cylinder(h=bottomh,d=tubed+tolerance+2,$fn=60);
}


module threadedtube() {
    
    difference() {
        union() {
            cylinder(h=th,d=tubed, $fn=6);
            cylinder(h=th+ringgriph,d=outerd-tolerance, $fn=60);
        }
        translate([0,0,th]) cylinder(h=2,d=innerd+tolerance, $fn=60);
        tap(thread, turns=(((th)/threadp))-0.4);
        
        translate([0,0,3]) rotate([90,0,0]) cylinder(h=bottoms,d=4,center=true,$fn=60);
        rotate([0,0,60]) translate([0,0,3]) rotate([90,0,0]) cylinder(h=bottoms,d=4,center=true,$fn=60);
        rotate([0,0,120]) translate([0,0,3]) rotate([90,0,0]) cylinder(h=bottoms,d=4,center=true,$fn=60);
    }
}


module wrench() {
    thick=3;
    difference() {
        union() {
            translate([8,0,0]) cylinder(h=thick,d=tubed+12);
            translate([0,-tubed/4,0]) rotate([0,0,-30]) cube([120,2*tubed/3,thick]);
        }
        hull() {
            cylinder(h=thick,d=tubed+1, $fn=6);
            translate([-25,0,0])cylinder(h=thick,d=tubed+1, $fn=6);
        }
    }

}
