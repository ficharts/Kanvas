package landray.kp.maps.main.elements
{
	import model.vo.ElementVO;
	
	import view.element.IElement;
	
	/**
	 */	
	public class Group extends Element
	{
		public function Group($vo:ElementVO)
		{
			super($vo);
		}
		
		/**
		 */		
		override public function getChilds(group:Vector.<IElement>):Vector.<IElement>
		{
			var element:IElement;
			
			for each (element in childElements)
				group = element.getChilds(group);
			
			group.push(this);
			
			return group;
		}
		
		/**
		 */		
		public var childElements:Vector.<IElement> = new Vector.<IElement>;
	}
}