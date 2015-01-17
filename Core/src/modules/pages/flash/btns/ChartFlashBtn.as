package modules.pages.flash.btns
{
	import modules.pages.flash.FlashChart;
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	
	public class ChartFlashBtn extends FlashBtnBS
	{
		public function ChartFlashBtn(fh:FlasherHolder)
		{
			super(fh);
			
			text = "图表"
		}
		
		/**
		 */		
		override public function get key():String
		{
			return "chart";
		}
		
		/**
		 */		
		override public function get flash():IFlash
		{
			return new FlashChart;
		}
	}
}