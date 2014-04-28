package view.elementSelector.scaleRollControl
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	
	import model.ConfigInitor;
	
	import view.editor.text.ScalPointControl;
	import view.elementSelector.ControlPointBase;
	import view.elementSelector.ElementSelector;
	import view.elementSelector.IPointControl;
	
	/**
	 * 图形比例与旋转的控制
	 */	
	public class ScaleRollControl extends Sprite implements IPointControl
	{
		public function ScaleRollControl(selector:ElementSelector)
		{
			super();
			
			this.selector = selector;
			
			scale_up;
			scale_over;
			scale_down;
			scalePoint.iconW = scalePoint.iconH = ConfigInitor.ICON_SIZE_FOR_SCALE_AND_ROLL;
			scalePoint.setIcons("scale_up", "scale_over", "scale_down");
			addChild(scalePoint);
			scaleControl = new ScaleControl(selector, scalePoint);
			
			
			// 旋转控制
			roll_up;
			roll_over;
			roll_down;
			rollPoint.iconW = rollPoint.iconH = ConfigInitor.ICON_SIZE_FOR_SCALE_AND_ROLL;
			rollPoint.setIcons("roll_up", "roll_over", "roll_down");
			addChild(rollPoint);
			roteControl = new RoteControl(selector, rollPoint);
		}
		
		/**
		 */		
		public function layout(style:Style):void
		{
			if (visible)
			{
				rollPoint.x = style.tx;
				
				scalePoint.x = style.width * .5;
				
				fitPoint.x = Math.max(style.tx, Math.min(-ConfigInitor.ICON_SIZE_FOR_SCALE_AND_ROLL, style.tx + ConfigInitor.ICON_SIZE_FOR_SCALE_AND_ROLL + 5));
				rollPoint.y = scalePoint.y = fitPoint.y = style.height * .5;
				fitPoint.visible = selector.element.isPage;
			}
		}
		
		/**
		 * 控制比例缩放 
		 */		
		private var scaleControl:ScaleControl;
		
		/**
		 * 控制旋转 
		 */		
		private var roteControl:RoteControl;
		
		/**
		 *  左下方控制点, 控制旋转
		 */		
		public var rollPoint:IconBtn = new IconBtn;
		
		/**
		 * 右下方控制点 ， 控制比例缩放
		 */		
		public var scalePoint:IconBtn = new IconBtn;
		
		/**
		 * 自适应页面控制点
		 */	
		public var fitPoint:IconBtn = new IconBtn;
		
		/**
		 */		
		private var selector:ElementSelector;
			
	}
}