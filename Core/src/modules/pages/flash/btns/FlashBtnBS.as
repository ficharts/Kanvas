package modules.pages.flash.btns
{
	import com.kvs.ui.button.LabelBtn;
	
	import modules.pages.flash.FlasherHolder;
	import modules.pages.flash.IFlash;
	
	/**
	 */	
	public class FlashBtnBS extends LabelBtn
	{
		public function FlashBtnBS(fh:FlasherHolder)
		{
			super();
		}
		
		/**
		 */		
		public function get key():String
		{
			return "";
		}
		
		/**
		 */		
		public function get flash():IFlash
		{
			return null;
		}
		
		/**
		 */		
		private var fher:FlasherHolder
	}
}