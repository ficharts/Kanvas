package modules.pages.flash.btns
{
	import modules.pages.flash.EnlargeFlash;
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	
	/**
	 */	
	public class EnlargeBtn extends FlashBtnBS
	{
		public function EnlargeBtn(fh:FlasherHolder)
		{
			super(fh);
			
			text = "放大"
		}
		
		/**
		 */		
		override public function get key():String
		{
			return "enlarge";
		}
		
		/**
		 */		
		override public function get flash():IFlash
		{
			return new EnlargeFlash;
		}
	}
}