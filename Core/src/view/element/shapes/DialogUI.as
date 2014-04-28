package view.element.shapes
{
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import model.vo.DialogVO;
	
	import view.element.ElementBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.customPoint.CustomPointControl;
	import view.elementSelector.customPoint.ICustomShape;
	import view.elementSelector.toolBar.ToolBarController;
	
	/**
	 * 对话框UI
	 */	
	public class DialogUI extends ShapeBase implements ICustomShape
	{
		public function DialogUI(vo:DialogVO)
		{
			super(vo);
			
			xmlData = <dialog/>;
			
		}
		 
		/**
		 */		
		override public function exportData():XML
		{
			xmlData = super.exportData();
			
			xmlData.@r = dialogVO.r;
			xmlData.@rAngle = dialogVO.rAngle;
			xmlData.@radius = dialogVO.radius;
			
			return xmlData;
		}
		
		/**
		 */		
		public function customRender(selector:ElementSelector, control:CustomPointControl):void
		{
			var scale:Number = selector.layoutInfo.transformer.canvasScale * vo.scale;
			
			//对话框边角控制
			if (control == dialogPointCt)
			{
				var angle:Number = selector.currentRote;
				//angle += 90;
				
				//trace(angle, dialogVO.rotation, selector.coreMdt.canvas.rotation);
				dialogVO.rAngle = angle - dialogVO.rotation //- selector.coreMdt.canvas.rotation; 
				dialogVO.r = selector.curRDis / scale;
			}
			else//圆角控制
			{
				var x:Number = selector.mouseX;
				
				if (x < - vo.width / 2 * scale)
					x = - vo.width / 2 * scale;
				
				if (x > 0)
					x = 0;
				
				dialogVO.radius = (x + vo.width / 2 * scale) / scale;
			}
			
			this.render();
			selector.render();
		}
		
		/**
		 */		
		public function layoutCustomPoint(selector:ElementSelector, style:Style):void
		{
			selector.customPointControl.x = (- vo.width / 2 + dialogVO.radius) * style.scale;
			selector.customPointControl.y = - vo.height / 2 * style.scale;
			
			var rad:Number = dialogVO.rAngle / 180 * Math.PI;
			dialogPointCt.x = dialogVO.r * Math.cos(rad) * style.scale;
			dialogPointCt.y = dialogVO.r * Math.sin(rad) * style.scale;
		}
		
		/**
		 */		
		public function get propertyNameArray():Array
		{
			return _propertyNameArray;
		}
		
		private const _propertyNameArray:Array = ["radius", 'r', 'rAngle'];
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var rectVO:DialogVO = new DialogVO;
			rectVO.radius = this.dialogVO.radius;
			rectVO.r = this.dialogVO.r;
			rectVO.rAngle = this.dialogVO.rAngle;
			
			return new DialogUI(cloneVO(rectVO) as DialogVO);
		}
		
		/**
		 */		
		protected function get dialogVO():DialogVO
		{
			return vo as DialogVO;
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			//先绘制遮罩图形
			vo.style.radius = dialogVO.radius * 2;
			
			var rad:Number = dialogVO.rAngle / 180 * Math.PI;
			var cP:Point = new Point(dialogVO.r * Math.cos(rad), dialogVO.r * Math.sin(rad));
			
			var r:Number;
			
			if (vo.width > vo.height)
				r = vo.height / 4;
			else 
				r = vo.width / 4;
			
			var nRad:Number = rad - Math.PI / 2; 
			var rP:Point = new Point(r * Math.cos(nRad), r * Math.sin(nRad));
			
			nRad = rad + Math.PI / 2;
			var lP:Point = new Point(r * Math.cos(nRad), r * Math.sin(nRad));
			
			StyleManager.drawRect(this, vo.style, vo);
			StyleManager.setShapeStyle(vo.style, graphics, vo);
			graphics.moveTo(cP.x, cP.y);
			graphics.lineTo(rP.x, rP.y);
			graphics.lineTo(lP.x, lP.y);
			graphics.lineTo(cP.x, cP.y);
			graphics.endFill();
		}
		
		/**
		 */		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.fillShape);
		}
		
		/**
		 */		
		private var maskShape:Sprite = new Sprite;
		
		/**
		 * 对话框控制点 
		 */		
		private var dialogPointCt:CustomPointControl;
		
		/**
		 */		
		override public function showControlPoints(selector:ElementSelector):void
		{
			super.showControlPoints(selector);
			
			ViewUtil.show(selector.customPointControl);
			
			if(dialogPointCt == null)
			{
				dialogPointCt = new CustomPointControl(selector);
				selector.addControl(dialogPointCt);
			}
			
			ViewUtil.show(dialogPointCt);
		}
		
		/**
		 * 隐藏型变控制点
		 */		
		override public function hideControlPoints(selector:ElementSelector):void
		{
			super.hideControlPoints(selector);
			
			ViewUtil.hide(selector.customPointControl);
			ViewUtil.hide(dialogPointCt);
		}
		
		/**
		 * 
		 */		
		override public function hideFrameOnMdown(selector:ElementSelector):void
		{
			super.hideFrameOnMdown(selector);
			
			ViewUtil.hide(selector.customPointControl);
			ViewUtil.hide(dialogPointCt);
		}
		
		/**
		 */		
		override public function showSelectorFrame(selector:ElementSelector):void
		{
			super.showSelectorFrame(selector);
			
			ViewUtil.show(selector.customPointControl);
			ViewUtil.show(dialogPointCt);
		}
	}
}