package view.element.state
{
	import view.element.ElementBase;
	
	/**
	 */	
	public class ElementPrevState extends ElementStateBase
	{
		public function ElementPrevState(element:ElementBase)
		{
			super(element);
		}
		
		/**
		 */		
		override public function returnFromPrevState():void
		{
			element.returnFromPrevFun();
		}
		
		/**
		 */
		override public function mouseOver():void
		{
		}
		
		/**
		 */
		override public function mouseOut():void
		{
		}
		
		/**
		 */		
		override public function startMove():void
		{
		}
		
		/**
		 */		
		override public function stopMove():void
		{
		}
		
		/**
		 */		
		override public function enable():void
		{
			
		}
		
		/**
		 */		
		override public function disable():void
		{
			
		}
		
	}
}