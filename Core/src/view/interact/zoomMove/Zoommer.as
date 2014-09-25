package view.interact.zoomMove
{
	import consts.ConstsTip;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import util.LayoutUtil;
	
	import view.ui.Bubble;
	import view.ui.canvas.Canvas;
	import view.ui.MainUIBase;

	/**
	 * 画布缩放控制
	 */
	public class Zoommer
	{
		/**
		 */
		public function Zoommer(control:ZoomMoveControl)
		{
			this.control = control;
		}
		
		/**
		 */		
		private var control:ZoomMoveControl;
		
		/**
		 */		
		private function get canvas():Canvas
		{
			return control.mainUI.canvas;
		}
		
		/**
		 */		
		private function get mainUI():MainUIBase
		{
			return control.mainUI;
		}
		
		/**
		 */		
		private function get flasher():Flasher
		{
			return control.flasher;
		}
		
		
		
		
		
		
		//--------------------------------------------------------------
		//
		//
		//
		//  缩放指令
		//
		//
		//---------------------------------------------------------------
		
		
		/**
		 * 放大画布
		 */
		public function zoomIn(center:* = false):void
		{
			flasher.ready();
			
			var newScale:Number = flasher.canvasTargetScale * control.zoomScale;
			
			if (newScale > maxScale)
			{
				newScale = maxScale;
				Bubble.show(ConstsTip.TIP_ZOOM_MAX);
			}
			
			zoom(newScale, center);
			
			flasher.flash(0.5);
		}
		
		/**
		 * 缩小画布
		 */
		public function zoomOut(center:* = false):void
		{
			flasher.ready();
			
			var newScale:Number = flasher.canvasTargetScale / control.zoomScale;
			if (newScale < minScale)
			{
				newScale = minScale;
				Bubble.show(ConstsTip.TIP_ZOOM_MIN);
			}
			
			zoom(newScale, center);
			
			flasher.flash(0.5);
		}
		
		public function zoomMoveOff(scale:Number, x:Number, y:Number, time:Number = 1, ease:Object = null):void
		{
			flasher.ready();
			flasher.canvasTargetScale = canvas.scaleX * scale;
			flasher.canvasTargetX = canvas.x + x;
			flasher.canvasTargetY = canvas.y + y;
			flasher.flash(time, ease);
		}
		
		public function zoomRotateMoveTo(scale:Number, rotation:Number, x:Number, y:Number, ease:Object = null, time:Number = NaN):void
		{
			flasher.ready();
			
			flasher.canvasTargetScale = scale;
			flasher.canvasTargetRotation = rotation;
			flasher.canvasTargetX = x;
			flasher.canvasTargetY = y;
			
			flasher.advancedFlash(ease, time);
		}
		
		/**
		 * 画布中心点到鼠标的距离 × 缩放偏移量  + 画布中心点   + 图形中心点到画布中心点距  × 新比例
		 * 
		 * 整个过程中画布中心点为图形的注册点， 缩放是以此为基准进行的
		 */		
		private function zoom(newScale:Number, center:* = false):void
		{
			var curScale:Number = canvas.scaleX;
			var scaleDis:Number = newScale - curScale;
			flasher.canvasTargetScale = newScale;
			
			if (center is Point)
			{
				point.x = center.x;
				point.y = center.y;
			}
			else
			{
				if (center) 
				{
					point.x = canvas.stage.stageWidth  * .5;
					point.y = canvas.stage.stageHeight * .5;
				}
				else 
				{
					point.x = canvas.stage.mouseX;
					point.y = canvas.stage.mouseY;
				}
			}
			
			flasher.canvasTargetX = (canvas.stage.stageWidth / 2 - point.x) * scaleDis / curScale 
							   + canvas.stage.stageWidth / 2 + (canvas.x - canvas.stage.stageWidth / 2) / curScale * newScale;
			
			flasher.canvasTargetY = (canvas.stage.height / 2 - point.y) * scaleDis / curScale 
				+ canvas.stage.height / 2 + (canvas.y - canvas.stage.height / 2) / curScale * newScale;
		}
		
		/**
		 * 内容填满画布并居中, 没有内容时， 画布比例为1:1
		 * 
		 * 并居中
		 */
		public function zoomAuto(originalScale:Boolean = false):void
		{
			flasher.ready();
			
			flasher.canvasTargetRotation = 0;
			
			if (canvas.ifHasElements)
			{
				canvasBound = LayoutUtil.getContentRect(canvas, false);
				
				var scale:Number = (canvasBound.width / canvasBound.height > mainUI.autofitRect.width / mainUI.autofitRect.height)
					? mainUI.autofitRect.width  / canvasBound.width
					: mainUI.autofitRect.height / canvasBound.height;
				
				//画布保持原比例，不缩放
				flasher.canvasTargetScale = (originalScale || (!control.ifAutoZoom && !(canvasBound.width < mainUI.autofitRect.width && canvasBound.height < mainUI.autofitRect.height))) ? 1 : scale;
				
				canvasBound.width  *= scale;
				canvasBound.height *= scale;
				var tl:Point = canvasBound.topLeft.clone();
				LayoutUtil.convertPointCanvas2Stage(tl, canvas.x, canvas.y, flasher.canvasTargetScale, flasher.canvasTargetRotation);
				canvasBound.x = tl.x;
				canvasBound.y = tl.y;
				
				var canvasCenter:Point = new Point((canvasBound .left + canvasBound .right) * .5, (canvasBound .top + canvasBound .bottom) * .5);
				var stageCenter :Point = new Point((mainUI.autofitRect.left + mainUI.autofitRect.right) * .5, (mainUI.autofitRect.top + mainUI.autofitRect.bottom) * .5);
				flasher.canvasTargetX = canvas.x + stageCenter.x - canvasCenter.x;
				flasher.canvasTargetY = canvas.y + stageCenter.y - canvasCenter.y;
			}
			else
			{
				flasher.canvasTargetScale = 1;
				flasher.canvasTargetX = mainUI.stage.stageWidth / 2;
				flasher.canvasTargetY = mainUI.stage.stageHeight / 2;
			}
			
			flasher.advancedFlash();
		}
		
		/**
		 */		
		public static var maxScale:Number = 100000000000000;
		
		/**
		 */		
		public static var minScale:Number = 0.0000000000001;
		
		
		/**
		 * 画布canvas相对于主UI的布局
		 */
		private var canvasBound:Rectangle;
		
		/**
		 * 画布canvas中的内容相对于自身的布局 
		 */		
		private var canvasInerBound:Rectangle;
		
		private var point:Point = new Point;
		
	}
}