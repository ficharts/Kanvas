package view.toolBar
{
	import com.kvs.ui.button.IconBtn;
	
	import flash.display.Sprite;

	public class ToolBarStateBS
	{
		/**
		 */		
		public function ToolBarStateBS(toolbar:ToolBar)
		{
			this.tb = toolbar;
			tb.addChild(ctner);
		}
		
		/**
		 */		
		internal var ctner:Sprite = new Sprite;
		
		/**
		 */		
		public function init():void
		{
			
		}
		
		/**
		 */		
		public function updateLayout():void
		{
			
		}
		
		/**
		 */		
		public function toNomal():void
		{
			
		}
		
		/**
		 */		
		public function toPageEdit():void
		{
			
		}
		
		/**
		 */		
		public function toChartEdit():void
		{
			
		}
		
		public function addCustomButtons(btns:Vector.<IconBtn>):void
		{
			
		}
		
		/**
		 */		
		protected var tb:ToolBar;
	}
}