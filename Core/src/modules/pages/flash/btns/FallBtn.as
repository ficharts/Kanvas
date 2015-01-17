package modules.pages.flash.btns
{
	import modules.pages.flash.Fall;
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	
	public class FallBtn extends FlashBtnBS
	{
		public function FallBtn(fh:FlasherHolder)
		{
			super(fh);
			
			text = "跌落"
		}
		
		/**
		 */		
		override public function get key():String
		{
			return "fall";
		}
		
		/**
		 */		
		override public function get flash():IFlash
		{
			return new Fall;
		}
		
		
	}
}