package modules.pages.flash.btns
{
	import modules.pages.flash.FlashFromLeft;
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	
	public class FlashFromLeftBtn extends FlashBtnBS
	{
		public function FlashFromLeftBtn(fh:FlasherHolder)
		{
			super(fh);
			
			text = "飞入"
		}
		
		/**
		 */		
		override public function get key():String
		{
			return "fromLeft";
		}
		
		/**
		 */		
		override public function get flash():IFlash
		{
			return new FlashFromLeft;
		}
	}
}