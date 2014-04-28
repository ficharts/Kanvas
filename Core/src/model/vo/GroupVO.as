package model.vo
{
	/**
	 * 组合的VO
	 */	
	public class GroupVO extends ElementVO
	{
		public function GroupVO()
		{
			super();
			
			styleType = 'group';
			type = 'group';
		}
		
		/**
		 */		
		private var _childs:Array = [];

		/**
		 *  子元素ID集合
		 */
		public function get childs():Array
		{
			return _childs;
		}

		/**
		 * @private
		 */
		public function set childs(value:Array):void
		{
			_childs = value;
		}

	}
}