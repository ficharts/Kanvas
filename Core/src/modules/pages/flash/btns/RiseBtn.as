package modules.pages.flash.btns
{
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	import modules.pages.flash.Rise;
	
	public class RiseBtn extends FlashBtnBS
	{
		public function RiseBtn(fh:FlasherHolder)
		{
			super(fh);
			
			text = "上升"
		}
		
		/**
		 */		
		override public function get key():String
		{
			return "rise";
		}
		
		/**
		 */		
		override public function get flash():IFlash
		{
			return new Rise;
		}
	}
}