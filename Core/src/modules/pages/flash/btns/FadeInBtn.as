package modules.pages.flash.btns
{
	import modules.pages.flash.FadeIn;
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	
	public class FadeInBtn extends FlashBtnBS
	{
		public function FadeInBtn(fh:FlasherHolder)
		{
			super(fh);
			
			text = "淡入"
		}
		
		/**
		 */		
		override public function get key():String
		{
			return "fadeIn";
		}
		
		/**
		 */		
		override public function get flash():IFlash
		{
			return new FadeIn;
		}
		
		
	}
}