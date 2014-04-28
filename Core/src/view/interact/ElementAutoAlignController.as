package view.interact
{
	import com.kvs.utils.MathUtil;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import util.CoreUtil;
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.ui.Canvas;

	public final class ElementAutoAlignController
	{
		public function ElementAutoAlignController($elements:Vector.<ElementBase>, $canvas:Canvas, $shape:Shape, $coreMdt:CoreMediator)
		{
			elements = $elements;
			canvas = $canvas;
			shape = $shape;
			coreMdt = $coreMdt;
		}
		
		/**
		 * 清除shape绘制的虚线
		 */
		public function clear():void
		{
			shape.graphics.clear();
			clearHoverEffect();
		}
		
		/**
		 * 检查移动位置,移动对象时调用
		 */
		public function checkPosition(element:ElementBase, point:Point = null, axis:String = "x"):Point
		{
			if (enabled)
			{
				shape.graphics.clear();
				tempPoint = (point) ? checkPoint(element, point, axis) : checkElement(element);
			}
			return (enabled) ? tempPoint : null;
		}
		
		
		/**
		 * @private
		 * 基于元素的检测，主要用于检测元素移动
		 */
		private function checkElement(current:ElementBase):Point
		{
			tempPoint.x = NaN;
			tempPoint.y = NaN;
			//元素１检测的属性集
			var e1pArr:Array = [xArr, yArr];
			var alignArr:Array = [false, false];
			//存储直线a,b,c变量
			for (var i:int = 0; i < 2; i++)
			{
				var elementsLoopBreak:Boolean = false;
				for each (var element:ElementBase in elements)
				{
					if (checkElementAutoAlignable(current, element))
					{
						var plus:Number = current.rotation - element.rotation;
						//判断元素１的横向是对元素２的横向还是纵向进行对齐检测
						if (plus % 90 == 0)
						{
							var bool:Boolean = (plus % 180 == 0);
							//元素２检测的属性集
							var e2pArr:Array = (bool) ? [xArr, yArr] : [yArr, xArr];
							var j:int = 0;
							var k:int = 0;
							while (j < 3)
							{
								var e1p:String = e1pArr[i][j];
								var e2p:String = e2pArr[i][k];
								//获取移动点
								var curPoint:Point = getPoint(current, e1p);
								//获得判断点
								var chkPoint:Point = getPoint(element, e2p);
								//第一直线经过的点
								var points1:Array = getOriginPointsByProperty(current, e1p);
								//第二直线经过的点
								var points2:Array = getTargetPointsByProperty(element, e2p);
								//两直线相交的点
								var aimPoint:Point = getPointByIntersect(points1, points2);
								//距离判断
								var dis:Number = distance(aimPoint, curPoint);
								if (dis < areaPosition)
								{
									alignArr[i] = new Point;
									drawLineInPoints(Point.interpolate(points2[0], points2[1], .5), aimPoint);
									//此方向的增量向量
									alignArr[i].x = tempPoint.x = aimPoint.x - curPoint.x;
									alignArr[i].y = tempPoint.y = aimPoint.y - curPoint.y;
									elementsLoopBreak = true;
									break;
								}
								if (++k >= 3)
								{
									j++;
									k = 0;
								}
							}//end of while
						}//end of if plus
						if (elementsLoopBreak) break;
					}
				}//end of for element
			}//end of for i
			if (alignArr[0] && alignArr[1])
			{
				tempPoint.setTo(alignArr[0].x + alignArr[1].x, alignArr[0].y + alignArr[1].y);
			}
			return tempPoint;
		}
		
		/**
		 * @private
		 * 基于点的检测，主要用于检测形变
		 */
		private function checkPoint(current:ElementBase, point:Point, axis:String = "x"):Point
		{
			tempPoint.x = NaN;
			tempPoint.y = NaN;
			var elementsLoopBreak:Boolean = false;
			for each (var element:ElementBase in elements)
			{
				if (checkElementAutoAlignable(current, element))
				{
					var plus:Number = current.rotation - element.rotation;
					if (plus % 90 == 0)
					{
						var bool:Boolean = (plus % 180 == 0);
						//元素２检测的属性集
						var pArr:Array = (bool) ? ((axis == "x") ? xArr : yArr) : ((axis == "x") ? yArr : xArr);
						var j:int = 0;
						while (j < 3)
						{
							var e1p:String = axis;
							var e2p:String = pArr[j];
							//获取移动点
							var curPoint:Point = point;
							//获得判断点
							var chkPoint:Point = getPoint(element, e2p);
							//第一直线经过的点
							var points1:Array = getOriginPointsByProperty(current, e1p);
							//第二直线经过的点
							var points2:Array = getTargetPointsByProperty(element, e2p);
							//两直线相交的点
							var aimPoint:Point = getPointByIntersect(points1, points2);
							//距离判断
							if (distance(aimPoint, curPoint) < areaPosition)
							{
								drawLineInPoints(Point.interpolate(points2[0], points2[1], .5), aimPoint);
								//此方向的增量向量
								tempPoint.setTo(aimPoint.x, aimPoint.y);
								elementsLoopBreak = true;
								break;
							}
							j++;
						}//end of while
					}
					if (elementsLoopBreak) break;
				}
			}//end of for element
			return tempPoint;
		}
		
		private function distance(p1:Point, p2:Point):Number
		{
			return Point.distance(p1, p2) * canvas.scaleX;
		}
		
		/**
		 * 检查旋转角度,旋转时调用
		 */
		public function checkRotation(element:ElementBase, rotation:Number):Number
		{
			if (enabled)
			{
				clearHoverEffect();
				
				rotation = MathUtil.modRotation(rotation);
				var mod:Number = rotation % 45;
				if (mod < areaRotation)
					rotation -= mod;
				else if (mod > 45 - areaRotation)
					rotation += (45 - mod);
				else
					rotation = checkValue(element, rotation, "rotation");
				
				if (currentAlignElement)
				{
					coreMdt.coreApp.hoverEffect.element = currentAlignElement;
					coreMdt.coreApp.hoverEffect.show();
				}
			}
			return (enabled) ? rotation : NaN;
		}
		
		/**
		 * 检查缩放,缩放时调用
		 */
		public function checkScale(element:ElementBase, scale:Number):Number
		{
			if (enabled)
			{
				clearHoverEffect();
				
				//scale = (element is TextEditField) ? NaN : checkValue(element, scale, "scaleX");
				scale = checkValue(element, scale, "scaleX");
				
				if (currentAlignElement)
				{
					coreMdt.coreApp.hoverEffect.element = currentAlignElement;
					coreMdt.coreApp.hoverEffect.show();
				}
			}
			return (enabled) ? scale : NaN;
		}
		
		private function checkValue(current:ElementBase, value:Number, property:String):Number
		{
			for each (var element:ElementBase in elements)
			{
				var result:Number = checkValueNear(current, element, value, element[property], property);
				if (!isNaN(result))
				{
					currentAlignElement = element;
					return result;
				}
			}
			return NaN;
		}
		
		private function checkValueNear(current:ElementBase, element:ElementBase, value1:Number, value2:Number, property:String):Number
		{
			var result:Number;
			if (checkElementAutoAlignable(current, element))
			{
				if (property == "rotation")
				{
					value1 = MathUtil.modRotation(value1);
					value2 = MathUtil.modRotation(value2);
					var mod:Number = (value1 - value2) % 90;
					var mda:Number = Math.abs(mod);
					if (mda < areaRotation)
					{
						result = value1 - mod;
					}
					else if (mda > 90 - areaRotation)
					{
						result = value1 - ((mod < 0) ? 90 + mod : mod - 90);
					}
					
				}
				else if (property == "scaleX")
				{
					if (getClass(current) == getClass(element) && (current.rotation - element.rotation) % 90 == 0)
					{
						var w1:Number = value1 * current.vo.width;
						var w2:Number = value2 * element.vo.width;
						var h1:Number = value1 * current.vo.height;
						var h2:Number = value2 * element.vo.height;
						var ds:Number = areaScale / canvas.scaleX;
						var dp:Number = areaPosition / canvas.scaleX;
						
						if (Math.abs(w1 - w2) < dp)
							result = w2 / current.vo.width;
						else if (Math.abs(w1 - h2) < dp)
							result = h2 / current.vo.width;
						else if (Math.abs(h1 - w2) < dp)
							result = w2 / current.vo.height;
						else if (Math.abs(h1 - h2) < dp)
							result = h2 / current.vo.height;
					}
				}
			}
			return result;
		}
		
		private function getClass(obj:Object):Object
		{
			return getDefinitionByName((getQualifiedClassName(obj)));
		}
		
		//根据属性获取element对应点
		private function getPoint(element:ElementBase, property:String):Point
		{
			return element[pointObj[property]];
		}
		
		//获取当前移动元素的检测点集合，形成直线
		private function getOriginPointsByProperty(element:ElementBase, property:String):Array
		{
			return [element[originPointObj[property][0]], element[originPointObj[property][1]]];
		}
		
		//获取检测元素的检测点集合，形成直线
		private function getTargetPointsByProperty(element:ElementBase, property:String):Array
		{
			return [element[targetPointObj[property][0]], element[targetPointObj[property][1]]];
		}
		
		//获取2直线相交的点
		private function getPointByIntersect(points1:Array, points2:Array):Point
		{
			//第一直线a1x+b1y+c1=0
			var a1:Number = points1[0].y - points1[1].y;
			var b1:Number = points1[1].x - points1[0].x;
			var c1:Number = points1[0].x * points1[1].y - points1[0].y * points1[1].x;
			//第二直线a2x+b2y+c2=0
			var a2:Number = points2[0].y - points2[1].y;
			var b2:Number = points2[1].x - points2[0].x;
			var c2:Number = points2[0].x * points2[1].y - points2[0].y * points2[1].x;
			//两直线相交的点
			var p:Number = 1 / (a1 * b2 - a2 * b1);
			return new Point((b1 * c2 - b2 * c1) * p, (a2 * c1 - a1 * c2) * p);
		}
		
		/**
		 * 清除当前目标对齐元素的hoverEffect
		 */
		private function clearHoverEffect():void
		{
			if (currentAlignElement)
			{
				currentAlignElement.clearHoverEffect();
				currentAlignElement = null;
			}
		}
		
		/**
		 * 在两点间画线
		 */
		private function drawLineInPoints(point1:Point, point2:Point):void
		{
			shape.graphics.lineStyle(.1, 0x555555);
			axisPoint1 = LayoutUtil.elementPointToStagePoint(point1.x, point1.y, canvas);
			axisPoint2 = LayoutUtil.elementPointToStagePoint(point2.x, point2.y, canvas);
			drawDashed(shape.graphics, axisPoint1, axisPoint2, 10, 10);
		}
		
		/**
		 * 绘制虚线
		 */
		private function drawDashed(graphics:Graphics, beginPoint:Point, endPoint:Point, width:Number, grap:Number):void
		{
			if (!graphics || !beginPoint || !endPoint || width <= 0 || grap <= 0) return;
			var Ox:Number = beginPoint.x;
			var Oy:Number = beginPoint.y;
			
			var radian:Number = Math.atan2(endPoint.y - Oy, endPoint.x - Ox);
			var totalLen:Number = Point.distance(beginPoint, endPoint);
			var currLen:Number = 0;
			var x:Number, y:Number;
			
			while (currLen <= totalLen)
			{
				x = Ox + Math.cos(radian) * currLen;
				y = Oy + Math.sin(radian) * currLen;
				graphics.moveTo(x, y);
				
				currLen += width;
				if (currLen > totalLen) currLen = totalLen;
				
				x = Ox + Math.cos(radian) * currLen;
				y = Oy + Math.sin(radian) * currLen;
				graphics.lineTo(x, y);
				
				currLen += grap;
			}
		}
		
		private function checkElementAutoAlignable(current:ElementBase, element:ElementBase):Boolean
		{
			return (element != current && 
					element.visible && 
					! CoreUtil.inGroup(current, element) && 
					! CoreUtil.elementOutOfInteract(element));
		}
		
		/**
		 * 启用或禁用自动缩放
		 */
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			if (value == enabled) return;
			_enabled = value;
			clear();
		}
		private var _enabled:Boolean = true;
		
		/**
		 * 移动时自动对齐的检测范围，像素为单位
		 * 
		 * @default 10
		 */
		public var areaPosition:Number = 5;
		
		/**
		 * 旋转时自动对齐的检测范围，角度为单位
		 * 
		 * @default 5
		 */
		public var areaRotation:Number = 5;
		
		/**
		 * 缩放时自动对齐的检测范围
		 */
		public var areaScale:Number = .05;
		
		/**
		 * 元素集合
		 */
		private var elements:Vector.<ElementBase>;
		
		/**
		 * 画布，用于获取缩放值
		 */
		private var canvas:Canvas;
		
		/**
		 * 虚线绘制UI
		 */
		private var shape:Shape;
		
		private var coreMdt:CoreMediator;
		
		/**
		 * 当前对齐的元素
		 */
		private var currentAlignElement:ElementBase;
		
		private var tempPoint:Point = new Point;
		
		private var axisPoint1:Point = new Point;
		
		private var axisPoint2:Point = new Point;
		
		
		private const xArr:Array = ["x", "left", "right"];
		private const yArr:Array = ["y", "top", "bottom"];
		private const originPointObj:Object = {
			x     :["middleLeft", "middleRight" ],
			left  :["middleLeft", "middleRight" ],
			right :["middleLeft", "middleRight" ],
			y     :["topCenter" , "bottomCenter"],
			top   :["topCenter" , "bottomCenter"],
			bottom:["topCenter" , "bottomCenter"]
		};
		private const targetPointObj:Object = {
			x     :["topCenter" , "bottomCenter"],
			left  :["topLeft"   , "bottomLeft"  ],
			right :["topRight"  , "bottomRight" ],
			y     :["middleLeft", "middleRight" ],
			top   :["topLeft"   , "topRight"    ],
			bottom:["bottomLeft", "bottomRight" ]
		};
		private const pointObj:Object = {
			left  :"middleLeft",
			right :"middleRight",
			top   :"topCenter",
			bottom:"bottomCenter",
			x     :"middleCenter",
			y     :"middleCenter"
		};
	}
}