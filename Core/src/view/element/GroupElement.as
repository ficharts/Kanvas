package view.element
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import model.CoreFacade;
	import model.vo.GroupVO;
	
	import view.element.state.ElementSelected;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 * 组合
	 */	
	public class GroupElement extends ElementBase implements IAutoGroupElement
	{
		public function GroupElement(vo:GroupVO)
		{
			super(vo);
		}
		
		/**
		 */		
		override public function exportData():XML
		{
			xmlData = <group/>;
			super.exportData();
			
			for each(var element:ElementBase in childElements)
				xmlData.appendChild(<{element.vo.type} id={element.vo.id}/>);
				
			return xmlData;
		}
		
		override public function toShotcut(renderable:Boolean=false):void
		{
			super.toShotcut(renderable);
			graphics.clear();
		}
		
		override public function toPreview(renderable:Boolean=false):void
		{
			super.toPreview(renderable);
			if (currentState is ElementSelected)
			{
				StyleManager.drawRect(this, vo.style, vo);
			}
			else
			{
				graphics.beginFill(0, 0);
				graphics.drawRect(vo.style.tx, vo.style.ty, vo.style.width, vo.style.height);
				graphics.endFill();
			}
		}
		
		/**
		 */		
		override public function copy():void
		{
			dispatchEvent(new ElementEvent(ElementEvent.COPY_GROUP, this));
		}
		
		/**
		 */		
		override public function paste():void
		{
			dispatchEvent(new ElementEvent(ElementEvent.PAST_GROUP, this));
		}
		
		/**
		 */		
		override public function getChilds(group:Vector.<ElementBase>):Vector.<ElementBase>
		{
			var elements:ElementBase;
			for each (elements in childElements)
				group = elements.getChilds(group);
			
			group.push(this);
			
			return group;
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var goupVO:GroupVO = new GroupVO;
			var group:GroupElement = new GroupElement(cloneVO(goupVO) as GroupVO);
			
			var element:ElementBase;
			var newElement:ElementBase;
			for each (element in childElements)
			{
				newElement = element.clone();
				newElement.toGroupState();
				group.childElements.push(newElement);
			}
			
			return group;
		}
		
		/**
		 */		
		override public function render():void
		{
			super.render();
			
			// 中心点为注册点
			vo.style.tx = - width  * .5;
			vo.style.ty = - height * .5;
			
			vo.style.width  = width;
			vo.style.height = height;
			
			graphics.clear();
			if (currentState is ElementSelected)
			{
				StyleManager.drawRect(this, vo.style, vo);
			}
			else
			{
				graphics.beginFill(0, 0);
				graphics.drawRect(vo.style.tx, vo.style.ty, vo.style.width, vo.style.height);
				graphics.endFill();
			}
		}
		
		/**
		 * 选择状态下才会呈现
		 */		
		override public function toSelectedState():void
		{
			graphics.clear();
			StyleManager.drawRect(this, vo.style, vo);
			
			super.toSelectedState();
		}
		
		/**
		 */		
		override public function toUnSelectedState():void
		{
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(vo.style.tx, vo.style.ty, vo.style.width, vo.style.height);
			graphics.endFill();
			
			super.toUnSelectedState();
		}
		
		/**
		 */		
		override public function toMultiSelectedState():void
		{
			super.toMultiSelectedState();
		}
		
		/**
		 */		
		override public function toGroupState():void
		{
			super.toGroupState();
		}
				
		/**
		 */		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.group);
		}
		
		/**
		 */		
		private var _childElements:Vector.<ElementBase> = new Vector.<ElementBase>;

		/**
		 */
		public function get childElements():Vector.<ElementBase>
		{
			return _childElements;
		}

		/**
		 * @private
		 */
		public function set childElements(value:Vector.<ElementBase>):void
		{
			_childElements = value;
		}
	}
}