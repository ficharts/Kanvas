package com.kvs.utils.graphic
{
  	import fl.motion.BezierSegment;
  	
  	import flash.display.Graphics;
  	import flash.geom.Point;
 
	public class CubicBezier
	{
		public static function drawCurve(g:Graphics, p1:Point, p2:Point, p3:Point, p4:Point):void
		{
			var bezier:BezierSegment = new BezierSegment(p1,p2,p3,p4);	
			g.moveTo(p1.x,p1.y);
			for (var t:Number = .01;t<1.01;t +=.01)
			{
				var val:Point = bezier.getValue(t);	
				g.lineTo(val.x,val.y);
			}
			
		}
		
		/**
		 *  绘制经过点的平滑贝塞尔曲线
		 */	
		public static function curveThroughPoints(g:Graphics, points:Array, z:Number = .5, 
												  angleFactor:Number = .75, moveTo:Boolean = true):void
		{
			try 
			{
				var p:Array = points.slice();	
				var duplicates:Array = new Array();	
				
				for (var i:int=0; i<p.length; i++)
				{
					if (!(p[i] is Point))
					{
						throw new Error("Array must contain Point objects");
					}
					
					if (i > 0)
					{
						if (p[i].x == p[i-1].x && p[i].y == p[i-1].y)
						{
							duplicates.push(i);
						}
					}
				}
				
				for (i = duplicates.length-1; i>=0; i--)
				{
					p.splice(duplicates[i],1);
				}
				
				if (z <= 0)
				{
					z = .5;
				}
				else if (z > 1)
				{
					z = 1;
				}
				
				if (angleFactor < 0)
				{
					angleFactor = 0;
				} 
				else if (angleFactor > 1)
				{
					angleFactor = 1;
				}
				
				if (p.length > 2)
				{
					var firstPt:int = 1;
					var lastPt:int = p.length-1;
					
					if (p[0].x == p[p.length-1].x && p[0].y == p[p.length-1].y)
					{
						firstPt = 0;
						lastPt = p.length;
					}
 
					var controlPts:Array = new Array();	
					for (i=firstPt; i<lastPt; i++) 
					{
						// The previous, current, and next points
						var p0:Point = (i-1 < 0) ? p[p.length-2] : p[i-1];	
						var p1:Point = p[i];
						var p2:Point = (i+1 == p.length) ? p[1] : p[i+1];		
						var a:Number = Point.distance(p0,p1);	
						if (a < 0.001) a = .001;		
						var b:Number = Point.distance(p1,p2);	
						if (b < 0.001) b = .001;
						var c:Number = Point.distance(p0,p2);	
						if (c < 0.001) c = .001;
						var cos:Number = (b*b+a*a-c*c)/(2*b*a);
						
						if (cos < -1) cos = -1;
						else if (cos > 1) cos = 1;
						var C:Number = Math.acos(cos);	
						
						var aPt:Point = new Point(p0.x-p1.x,p0.y-p1.y);
						var bPt:Point = new Point(p1.x,p1.y);
						var cPt:Point = new Point(p2.x-p1.x,p2.y-p1.y);
					
						if (a > b)
							aPt.normalize(b);	
						else if (b > a)
							cPt.normalize(a);	
						
						aPt.offset(p1.x,p1.y);
						cPt.offset(p1.x,p1.y);
						var ax:Number = bPt.x-aPt.x;	
						var ay:Number = bPt.y-aPt.y; 
						var bx:Number = bPt.x-cPt.x;	
						var by:Number = bPt.y-cPt.y;
						var rx:Number = ax + bx;	
						var ry:Number = ay + by;
						
						if (rx == 0 && ry == 0)
						{
							rx = -bx;	
							ry = by;
						}
						
						if (ay == 0 && by == 0)
						{
							rx = 0;
							ry = 1;
						} 
						else if (ax == 0 && bx == 0)
						{
							rx = 1;
							ry = 0;
						}
						
						var r:Number = Math.sqrt(rx*rx+ry*ry);	
						var theta:Number = Math.atan2(ry,rx);	
 
						var controlDist:Number = Math.min(a,b)*z;	
						var controlScaleFactor:Number = C/Math.PI;	
						controlDist *= ((1-angleFactor) + angleFactor*controlScaleFactor);	
						var controlAngle:Number = theta+Math.PI/2;	
						var controlPoint2:Point = Point.polar(controlDist,controlAngle);	
						var controlPoint1:Point = Point.polar(controlDist,controlAngle+Math.PI);	
						controlPoint1.offset(p1.x,p1.y);
						controlPoint2.offset(p1.x,p1.y);
						
						if (Point.distance(controlPoint2,p2) > Point.distance(controlPoint1,p2))
							controlPts[i] = new Array(controlPoint2,controlPoint1);	
						else 
							controlPts[i] = new Array(controlPoint1,controlPoint2);	
						
						/*
						g.moveTo(p1.x,p1.y);
						g.lineTo(controlPoint2.x,controlPoint2.y);
						g.moveTo(p1.x,p1.y);
						g.lineTo(controlPoint1.x,controlPoint1.y);
						*/						
					}
 
					//
					// Now draw the curve
					//
					// If moveTo condition is false, this curve can connect to a previous curve on the same graphics.
					if (moveTo) g.moveTo(p[0].x, p[0].y);
					else g.lineTo(p[0].x, p[0].y);
					
					if (firstPt == 1)
						g.curveTo(controlPts[1][0].x,controlPts[1][0].y,p[1].x,p[1].y);
					
					var straightLines:Boolean = true;	
					for (i = firstPt; i < lastPt - 1; i ++)
					{
						var isStraight:Boolean = ( ( i > 0 && Math.atan2(p[i].y-p[i-1].y,p[i].x-p[i-1].x) == Math.atan2(p[i+1].y-p[i].y,p[i+1].x-p[i].x) ) || ( i < p.length - 2 && Math.atan2(p[i+2].y-p[i+1].y,p[i+2].x-p[i+1].x) == Math.atan2(p[i+1].y-p[i].y,p[i+1].x-p[i].x) ) );
						
						if (straightLines && isStraight)
						{
							g.lineTo(p[i+1].x,p[i+1].y);
						} 
						else 
						{
							var bezier:BezierSegment = new BezierSegment(p[i],controlPts[i][1],controlPts[i+1][0],p[i+1]);
							for (var t:Number=.01;t<1.01;t+=.01)
							{
								var val:Point = bezier.getValue(t);	
								g.lineTo(val.x,val.y);
							}
						}
					}
					
					if (lastPt == p.length-1)
					{
						g.curveTo(controlPts[i][1].x,controlPts[i][1].y,p[i+1].x,p[i+1].y);
					}
					
				} 
				else if (p.length == 2)
				{	
					g.moveTo(p[0].x,p[0].y);
					g.lineTo(p[1].x,p[1].y);
				}
			} 
			catch (e:Error) 
			{
				trace(e.getStackTrace());
			}
		}
	}
}