package modules.pages.flash.btns
{
	import modules.pages.flash.FadeOut;
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	
	public class FadeOutBtn extends FlashBtnBS
	{
		public function FadeOutBtn(fh:FlasherHolder)
		{
			super(fh);
			
			text = "淡出"
		}
		
		/**
		 */		
		override public function get key():String
		{
			return "fadeOut";
		}
		
		/**
		 */		
		override public function get flash():IFlash
		{
			return new FadeOut;
		}
	}
}