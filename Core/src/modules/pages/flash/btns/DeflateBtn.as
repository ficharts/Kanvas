package modules.pages.flash.btns
{
	import modules.pages.flash.Deflate;
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	
	/**
	 */	
	public class DeflateBtn extends FlashBtnBS
	{
		public function DeflateBtn(fh:FlasherHolder)
		{
			super(fh);
			
			text = "缩小"
		}
		
		/**
		 */		
		override public function get key():String
		{
			return "deflate";
		}
		
		/**
		 */		
		override public function get flash():IFlash
		{
			return new Deflate;
		}
	}
}