package view.interact.multiSelect
{
	import com.kvs.ui.clickMove.ClickMoveControl;
	import com.kvs.ui.clickMove.IClickMove;
	
	import commands.Command;
	
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	
	import util.LayoutUtil;
	
	import view.element.ElementBase;
	import view.element.ElementEvent;
	import view.interact.CoreMediator;

	/**
	 * 多选与临时组合控制器
	 * 
	 * 当多选遇到组合时，仅组合元件被纳入选择，组合的子元件不纳入；
	 * 
	 * 对临时组合进行智能组合检测时，则纳入所有元件
	 */	
	public class MultiSelectControl implements IClickMove
	{
		public function MultiSelectControl(mdt:CoreMediator)
		{
			this.coreMdt = mdt;
			
			multiState = new MultiSelectState(this);
			normalState = new NormaSelectState(this);
			currState = normalState;
			
			temGroupElement = new TemGroupElement(this);
			
			
			mdt.coreApp.addEventListener(ElementEvent.TEM_GROUP_CHILD_DOWN, childDown);
			mdt.coreApp.addEventListener(ElementEvent.TEM_GROUP_CHILD_UP, childUp);
			mdt.coreApp.addEventListener(ElementEvent.START_MOVE_TEM_GROUP, startMoveGroup);
			mdt.coreApp.addEventListener(ElementEvent.STOP_MOVE_TEM_GROUP, stopMoveGroup);
			mdt.coreApp.addEventListener(ElementEvent.TEM_GROUP_CHILD_CLICKED, childChicked);
			
			dragSelectControl = new ClickMoveControl(this, coreMdt.coreApp);
		}
		
		
		/**
		 */		
		public function copy():void
		{
			elementsCoypied = this.childElements.concat();
		}
		
		/**
		 */		
		public function past():void
		{
		}
		
		/**
		 */		
		public var elementsCoypied:Vector.<ElementBase>;
		
		
		/**
		 * 对临时组合进行智能组合，鼠标按下时调用，此时如果存在组合，组合中的子元素也会被纳入智能组合中
		 */		
		public function autoTemGroup():void
		{
			var element:ElementBase;
			var autoGroup:Vector.<ElementBase> = new Vector.<ElementBase>;
			for each (element in this.childElements)
				autoGroup = element.getChilds(autoGroup);
			
			coreMdt.autoGroupController.setGroupElements(autoGroup);
		}
		
		
		
		
		
		
		//-----------------------------------------------------------
		//
		//
		//  框选临时组合控制
		//
		//
		//-----------------------------------------------------------
		
		
		/**
		 */				
		public function moveOff(xOff:Number, yOff:Number):void
		{
			currState.dragSelecting();
		}
		
		/**
		 * 当鼠标按下对象，没有拖动就释放时触发此方法
		 */		
		public function clicked():void
		{
		}
		
		/**
		 */		
		public function startMove():void
		{
			currState.startDragSelect();
		}
		
		/**
		 */			
		public function stopMove():void
		{
			currState.stopDragSelect();
		}
		
		/**
		 *  
		 */		
		internal function get dragSlectUI():Shape
		{
			return coreMdt.coreApp.dragSlectUI;
		}
		
		/**
		 * 框选交互控制器 
		 */		
		private var dragSelectControl:ClickMoveControl;
		
		
		
		
		
		
		
		
		
		
		
		//-----------------------------------------------------------
		//
		//
		//  临时组合的生成与消除
		//
		//
		//-----------------------------------------------------------
		
		
		/**
		 * 全选
		 */		
		public function selectAll():void
		{
			var element:ElementBase;
			var elements:Vector.<ElementBase> = CoreFacade.coreProxy.elements;
			var temGroup:Vector.<ElementBase> = new Vector.<ElementBase>;
			for each (element in elements)
				temGroup = element.addToTemGroup(temGroup);
				
			checkGroup(temGroup);
		}
		
		/**
		 * 框选后生成新临时组合, 框选的条件是选框经过目标中心点，并且
		 * 
		 * 选框尺寸小于目标元件
		 */		
		public function checkGroupAfterDragSelect():void
		{
			//画布上所有存在的元素
			var allEles:Vector.<ElementBase> = CoreFacade.coreProxy.elements;
			
			//被框选了的元素
			var elesSelected:Vector.<ElementBase> = new Vector.<ElementBase>;
			var element:ElementBase;
			var ifHit:Boolean = false;
			for each (element in allEles)
			{
				ifHit = coreMdt.collisionDetection.ifHitElement(element, dragSlectUI);
				
				if (ifHit && element.scaledWidth * coreMdt.layoutTransformer.canvasScale < dragSlectUI.width && 
					element.scaledHeight * coreMdt.layoutTransformer.canvasScale < dragSlectUI.height)
				{
					elesSelected = element.addToTemGroup(elesSelected);
				}
			}
			
			checkGroup(elesSelected);
		}
		
		/**
		 * 将元素集纳入临时组合中
		 */		
		private function checkGroup(elesSelected:Vector.<ElementBase>):void
		{
			if (elesSelected.length == 1)
			{
				coreMdt.sendNotification(Command.UN_SELECT_ELEMENT);
				
				//将选中的元件设为当前元件
				coreMdt.sendNotification(Command.SElECT_ELEMENT, elesSelected[0]);
			}
			else if (elesSelected.length > 1)
			{
				coreMdt.sendNotification(Command.UN_SELECT_ELEMENT);
				
				childElements = childElements.concat(elesSelected);
				
				for each (var element:ElementBase in childElements)
					element.toMultiSelectedState();
				
				updateSelecterLayout();
				coreMdt.sendNotification(Command.SElECT_ELEMENT, temGroupElement);
			}
			else
			{
				//啥都没选上
			}
		}
		
		/**
		 */		
		public function del():void
		{
			coreMdt.sendNotification(Command.DELETE_CHILD_IN_TEM_GROUP);
		}
		
		/**
		 * 清除临时组合
		 */		
		public function clear():void
		{
			for each (var element:ElementBase in childElements)
				element.toUnSelectedState();
				
			childElements.length = 0;
			coreMdt.removeElementFromView(temGroupElement);
		}
		
		/**
		 * 点击选择方式添加临时组合
		 */		
		public function addToTemGroup(item:ElementBase):void
		{
			if (temGroupElement.parent)
			{
				item.toMultiSelectedState();
				childElements = item.addToTemGroup(childElements);
				updateSelecterLayout();
				
			}
			else// 刚开始创建临时组合
			{
				var curElement:ElementBase = coreMdt.currentElement;
				childElements = curElement.addToTemGroup(childElements);
				childElements = item.addToTemGroup(childElements);
				
				//此时编辑器处于选择模式, 先取消选择
				coreMdt.sendNotification(Command.UN_SELECT_ELEMENT);
				
				item.toMultiSelectedState();
				curElement.toMultiSelectedState();
				
				updateSelecterLayout();
				
				coreMdt.sendNotification(Command.SElECT_ELEMENT, temGroupElement);
			}
			
			
		}
		
		/**
		 * 临时组合构成发生改变时，刷新选择器的布局和图层状态
		 */		
		public function updateSelecterLayout():void
		{
			//var ifFirstCheckLayout:Boolean = true;	
			var left:Number = 0;
			var top:Number = 0;
			var bottom:Number = 0;
			var right:Number = 0;
			
			
			
			//var minIndex:uint = coreMdt.canvas.numChildren - 1;
			var index:uint;
			var leftArr:Array = [];
			var rightArr:Array = [];
			var topArr:Array = [];
			var bottomArr:Array = [];
			for each(var element:ElementBase in this.childElements)
			{
				//minIndex = Math.min(minIndex, index = element.index);
				
				// 子元素的布局信息；
				var elementRect:Rectangle = LayoutUtil.getItemRect(coreMdt.canvas, element, false, true);
				
				leftArr  .push(elementRect.left);
				rightArr .push(elementRect.right);
				topArr   .push(elementRect.top);
				bottomArr.push(elementRect.bottom);
			}
			
			//求元素集合边距范围
			left   = Math.min.apply(null, leftArr);
			right  = Math.max.apply(null, rightArr);
			top    = Math.min.apply(null, topArr);
			bottom = Math.max.apply(null, bottomArr);
			
			//先重设临时组合的比例和旋转角度
			temGroupElement.vo.scale = 1;
			temGroupElement.vo.rotation = temGroupElement.rotation = 0;
			
			//全局布局信息
			temGroupElement.vo.width  = (right - left) / coreMdt.canvas.scaleX;
			temGroupElement.vo.height = (bottom - top) / coreMdt.canvas.scaleX;
			
			temGroupElement.vo.x = (.5 * (left + right) - coreMdt.canvas.x) / coreMdt.canvas.scaleX;
			temGroupElement.vo.y = (.5 * (top + bottom) - coreMdt.canvas.y) / coreMdt.canvas.scaleX;
			
			//刷新UI
			temGroupElement.render();
			
			//确保临时组合位于子元件的最下层
			coreMdt.canvas.addChildAt(temGroupElement, 1);
			/*if (temGroupElement.parent == null)
				coreMdt.canvas.addChildAt(temGroupElement, index);
			else if (minIndex < temGroupElement.index)
				coreMdt.canvas.addChildAt(temGroupElement, index);*/
			
			//设定临时组合的内容
			autoTemGroup();
			
			coreMdt.selector.update();
		}
		
		
		
		
		
		
		
		
		
		
		
		//-----------------------------------------------------------
		//
		//
		//
		//  基础交互行为控制，包括点击，移动等基本交互行为；
		// 
		//  这些行为决定了临时组合中子元素的数量
		//
		//
		//-----------------------------------------------------------
		
		/**
		 */		
		private function startMoveGroup(evt:ElementEvent):void
		{
			currState.childStartMove();
		}
		
		/**
		 */		
		private function stopMoveGroup(evt:ElementEvent):void
		{
			currState.childStopMove();
		}
		
		/**
		 */		
		private function childDown(evt:ElementEvent):void
		{
			evt.stopPropagation();
			currState.childDown();
		}
		
		/**
		 */		
		private function childUp(evt:ElementEvent):void
		{
			evt.stopPropagation();
			currState.childUp();
		}
		
		/**
		 * 临时组合的的子元素被点击，如果此时处于多选模式下
		 * 
		 * 则从临时组合中剔除此元素
		 */		
		private function childChicked(evt:ElementEvent):void
		{
			currState.temGroupChildClicked(evt.element);
		}
		
		/**
		 * 鼠标按下时隐藏型变控制点
		 */		
		public function temGroupDown():void
		{
			currState.temGroupDown();
		}
		
		/**
		 * 鼠标释放后显示型变控制点，当仅仅点击临时组合而不移动时
		 * 
		 * 释放鼠标后需要接触此方法让隐藏了的控制点显现
		 */		
		public function temGroupUp():void
		{
			coreMdt.selector.showFrameOnMup();
		}
		
		/**
		 * 按下了非选择状态的元件
		 */		
		public function unSelectElementDown(element:ElementBase):void
		{
			currState.unSelectElementDown(element);
		}
		
		/**
		 * 点击了未被选择了的基本元件
		 */		
		public function unSelectElementClicked(element:ElementBase):void
		{
			currState.unSelectElementClicked(element);
		}
		
		/**
		 * 按下了选择状态下的元件
		 */		
		public function selectedElementDown(element:ElementBase):void
		{
			currState.selectedElementDown(element);
		}
		
		/**
		 * 点击了已被选择了的基本元件
		 */		
		public function selectedElementClicked(element:ElementBase):void
		{
			currState.selectedElementClicked(element);
		}
		
		/**
		 * 开始独立图形的移动
		 */		
		public function startMoveElement(ele:ElementBase):void
		{
			currState.startMoveElement(ele);
		}
		
		/**
		 */		
		public function stopMoveElement():void
		{
			currState.stopMoveElement();
		}
		
		/**
		 * 点击了画布背景
		 */		
		public function stageBGClicked():void
		{
			currState.stageBGClicked();
		}
		
		/**
		 */		
		public function toNomalState():void
		{
			currState = normalState;
			
			temGroupElement.enableBG();
			coreMdt.zoomMoveControl.enableBGInteract();
		}
		
		/**
		 */		
		public function toMultiState():void
		{
			currState = multiState;	
			
			//多选模式下防止临时组合遮盖住其他元件，
			//造成元件不可被点击。
			temGroupElement.disableBG();
			
			//禁止画布交互，因画布交互与框选交互有冲突
			coreMdt.zoomMoveControl.disableBgInteract();
		}
		
		/**
		 */		
		protected var multiState:MultiSelectStateBase;
		
		/**
		 */		
		protected var normalState:MultiSelectStateBase;
		
		/**
		 */		
		protected var currState:MultiSelectStateBase;
		
		/**
		 * 临时组合的内容
		 */		
		public var childElements:Vector.<ElementBase> = new Vector.<ElementBase>;
		
		/**
		 */		
		public var temGroupElement:TemGroupElement;
		
		/**
		 */		
		public var coreMdt:CoreMediator;
	}
}