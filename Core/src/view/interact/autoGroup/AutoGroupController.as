package view.interact.autoGroup
{
	import com.kvs.utils.MathUtil;
	import com.kvs.utils.PointUtil;
	
	import flash.geom.Point;
	
	import model.CoreFacade;
	import model.CoreProxy;
	import model.vo.PageVO;
	
	import modules.pages.PageUtil;
	
	import util.StyleUtil;
	
	import view.element.Camera;
	import view.element.ElementBase;
	import view.element.imgElement.ImgElement;
	import view.interact.CoreMediator;

	/**
	 * 智能组合控制器, 智能组合的对象仅仅包含基本的元件，不包含组合
	 * 
	 * 当进行移动，旋转，缩放，复制，删除，粘贴操作时
	 * 
	 * 堆积在一起的元素，如果其他元素都被当前元素包含，其他被包含
	 * 
	 * 元素一起纳入智能组合中;
	 * 
	 * 智能组合与当前元件配合共同完成智能操作
	 */	
	public class AutoGroupController
	{
		public function AutoGroupController(mdt:CoreMediator)
		{
			this.coreMdt = mdt;
		}
		
		/**
		 */		
		public function copyElements():void
		{
			elementsCopied = this.elements;
		}
		
		/**
		 */		
		public function pastElements(xOff:Number, yOff:Number):void
		{
			_elements.length = 0;
			
			elementsCopied.sort(sortOnIndex);
			
			for each (var element:ElementBase in this.elementsCopied)
			{
				var newElement:ElementBase = element.clone();
				StyleUtil.applyStyleToElement(newElement.vo);
				
				newElement.vo.x += xOff;
				newElement.vo.y += yOff;
				
				(newElement is Camera) ? CoreFacade.addElementAt(newElement, 1) : CoreFacade.addElement(newElement);
				
				_elements.push(newElement);
			}
		}
		
		private function sortOnIndex(a:ElementBase, b:ElementBase):int
		{
			if (a.index < b.index)
			{
				return -1;
			} 
			else if (a.index == b.index)
			{
				return 0;
			}
			else
			{
				return 1;
			}
		}
		
		/**
		 */		
		private var elementsCopied:Vector.<ElementBase>;
		
		/**
		 * 设定智能组合的内容，对临时组合进行编辑时会用到
		 */		
		public function setGroupElements(elements:Vector.<ElementBase>):void
		{
			clear();
			
			_elements = elements.concat();
		}
		
		/**
		 * 检测那些元素与当前点击的元素可以构成自由组合
		 * 
		 * 点击任意图形元素时触发
		 */		
		public function checkGroup(element:ElementBase, ifAll:Boolean = false):void
		{
			clear();
			coreMdt.collisionDetection.checkAutoGroup(element, this, ifAll);
		}
		
		/**
		 * 拖动元素和粘贴临时组合时触发，将智能组合中的元素平移
		 */		
		public function move(xOff:Number, yOff:Number, group:Boolean = false):void
		{
			if (enabled || group) 
			{
				for each(var element:ElementBase in _elements)
				{
					element.x = element.vo.x + xOff;
					element.y = element.vo.y + yOff;
				}
			}
		}
		
		/**
		 * 移动元素结束时触发
		 */		
		public function moveTo(xOff:Number, yOff:Number, group:Boolean = false):void
		{
			if (enabled || group) 
			{
				var point:Point = new Point();
				
				for each(var element:ElementBase in _elements)
				{
					point.x = element.vo.x + xOff;
					point.y = element.vo.y + yOff;
					
					element.moveTo(point);
				}
			}
		}
		
		/**
		 * 缩放当前元素过程时，缩放智能组合
		 */		
		public function scale(scaleRad:Number, curElement:ElementBase, group:Boolean = false):void
		{
			if (enabled || group) 
			{
				if (!(curElement is ImgElement))
				{
					var xDis:Number; 
					var yDis:Number;
					
					for each(var element:ElementBase in _elements)
					{
						element.scaleX = element.scaleY = element.vo.scale * scaleRad;
						
						xDis = element.vo.x - curElement.x;
						yDis = element.vo.y - curElement.y;
						
						element.x = curElement.x + xDis * scaleRad;
						element.y = curElement.y + yDis * scaleRad;
					}
				}
			}
		}
		
		/**
		 * 缩放当前元素结束时，缩放智能组合
		 */		
		public function scaleTo(scaleRad:Number, curElement:ElementBase, group:Boolean = false):void
		{
			if (enabled || group) 
			{
				var xDis:Number; 
				var yDis:Number;
				
				for each(var element:ElementBase in _elements)
				{
					element.scaleX = element.scaleY = element.vo.scale *= scaleRad;
					
					xDis = element.vo.x - curElement.x;
					yDis = element.vo.y - curElement.y;
					
					element.x = element.vo.x = curElement.x + xDis * scaleRad;
					element.y = element.vo.y = curElement.y + yDis * scaleRad;
				}
			}
		}
		
		/**
		 */		
		public function roll(dis:Number, curElement:ElementBase, group:Boolean = false):void
		{
			if (enabled || group) 
			{
				for each(var element:ElementBase in _elements)
				{
					element.rotation = element.vo.rotation + dis;
					tempRollPoint.setTo(element.vo.x, element.vo.y);
					PointUtil.rotate(tempRollPoint, MathUtil.angleToRadian(dis), curElement.middleCenter);
					element.x = tempRollPoint.x;
					element.y = tempRollPoint.y;
				}
			}
		}
		
		/**
		 */		
		public function rollTo(dis:Number, curElement:ElementBase, group:Boolean = false):void
		{
			if (enabled || group) 
			{
				for each(var element:ElementBase in _elements)
				{
					element.rotation = element.vo.rotation += dis;
					tempRollPoint.setTo(element.vo.x, element.vo.y);
					PointUtil.rotate(tempRollPoint, MathUtil.angleToRadian(dis), curElement.middleCenter);
					element.x = element.vo.x = tempRollPoint.x;
					element.y = element.vo.y = tempRollPoint.y;
				}
			}
		}
		
		private var tempRollPoint:Point = new Point;
				
		/**
		 * 清空智能组合的元素，每次只能组合检测时或者
		 * 
		 * 点击画布时触发
		 */		
		public function clear():void
		{
			_elements.length = 0;
		}
		
		/**
		 */		
		public function get ifHasElement():Boolean
		{
			if (_elements.length > 0)
				return true;
			else 
				return false;
		}
		
		public function hasElement(element:ElementBase):Boolean
		{
			return (_elements.indexOf(element) != -1);
		}
		
		/**
		 */		
		public function pushElement(element:IAutoGroupElement):void
		{
			_elements.push(element);
		}
		
		/**
		 */		
		public function resetElements(elements:Vector.<ElementBase>):void
		{
			this.clear();
			_elements = _elements.concat(elements);
		}
		
		
		
		/**
		 */		
		public function get elements():Vector.<ElementBase>
		{
			return _elements.concat();
		}
		
		/**
		 */		
		public var _elements:Vector.<ElementBase> = new Vector.<ElementBase>;
		
		public var enabled:Boolean = true;
		
		/**
		 * 
		 */		
		private var coreMdt:CoreMediator;
	}
}