package modules.pages.flash.btns
{
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	import modules.pages.flash.Rote;
	
	public class RoteBtn extends FlashBtnBS
	{
		public function RoteBtn(fh:FlasherHolder)
		{
			super(fh);
			
			text = "旋转"
		}
		
		/**
		 */		
		override public function get key():String
		{
			return "rote";
		}
		
		/**
		 */		
		override public function get flash():IFlash
		{
			return new Rote;
		}
	}
}