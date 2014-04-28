package view.interact.interactMode
{
	import commands.Command;
	
	import flash.geom.Point;
	
	import model.CoreFacade;
	
	import view.element.ElementBase;
	import view.interact.CoreMediator;

	/**
	 * 整个应用的选择模式, 有两种：非选择模式，选择模式
	 * 
	 * 其中还包含一个多选模式：control键处于按下状态；
	 * 
	 * 点击画布背景和，点击图形元件在不同模式下结果不同；
	 * 
	 * 单击画布背景：
	 * 
	 * 			        非选择模式：创建文本；
	 * 
	 * 			        选择模式：     取消选择；
	 * 
	 *             多选模式：     取消选择；
	 * 
	 * 单击图形元件：
	 * 
	 *             非选择模式：选择图形元件；
	 * 
	 *             选择模式：     创建文本框；
	 * 
	 *             多选模式：
	 * 
	 *                        点击未被选择的图形 clicked: 纳入选择集合；
	 * 
	 *                        点击已被纳入选择集合的元素：将其移除选择集合；
	 * 
	 * 
	 * 另，单击临时组合（此时已是选择状态）：
	 * 
	 *                                    单击组合的空白背景： 无作为；
	 * 
	 *                                    单击组合中的元素：
	 *                       
	 *                                                    选择模式： 取消多选，选择当前点击元件；
	 * 
	 *                                                    多选模式： 将点击元件移除多选集合
	 *  
	 * 
	 * 集合中元件的点击和一般元件点击好区分开，甚至在集合内部：子元件点击与背景点击都要分开            
	 *              
	 */	
	public class ModeBase
	{
		public function ModeBase(mainMediator:CoreMediator)
		{
			this.mainMediator = mainMediator;
		}
		
		/**
		 */		
		public function addPage(index:uint):void
		{
			
		}
		
		/**
		 * 选择模式下绘制的是以元素为基准，非选择模式下以画布镜头区域为基准
		 */		
		public function drawShotFrame():void
		{
			
		}
		
		/**
		 */		
		public function group():void
		{
			
		}
		
		/**
		 */		
		public function unGroup():void
		{
			
		}
		
		/**
		 * 非编辑状态下的全选
		 */		
		public function selectAll():void
		{
			mainMediator.multiSelectControl.selectAll();
		}
		
		/**
		 * 移动元件结束后呈现属性控制器
		 */		
		public function moveElementEnd():void
		{
			
		}
				
		/**
		 */		
		public function moveOff(xOff:Number, yOff:Number):void
		{
		}
		
		/**
		 * 选择状态下，移动元素时同步更新选择器位置
		 */		
		public function moveSelector(x:Number, y:Number):void
		{
			mainMediator.selector.x += x;
			mainMediator.selector.y += y;
		}
		
		/**
		 * 非编辑模式下有效
		 */		
		public function undo():void
		{
			
		}
		
		public function redo():void
		{
			
		}
		
		/**
		 * 选择和编辑模式下有效
		 */		
		public function esc():void
		{
			
		}
		
		/**
		 * 只有选择模式下才能复制
		 */		
		public function copy():void
		{
			
		}
		
		/**
		 * 只有选择模式下才能剪切
		 */		
		public function cut():void
		{
			
		}
		
		/**
		 * 非选择/选择模式下可以粘帖
		 */		
		public function paste():void
		{
			
		}
		
		/**
		 * 删除当前选中的元素, 仅在选择模式下才会被触发
		 */		
		public function del():void
		{
			
		}

		/**
		 * 
		 */		
		public function showSelector():void
		{
			
		}
		
		/**
		 * 缩放，移动画布时，要刷新选择框, 
		 * 
		 * 编辑状态下要更新编辑器的尺寸和位置
		 */		
		public function updateSelector():void
		{
			
		}
		
		/**
		 */		
		public function hideSelector():void
		{
			
		}
		
		/**
		 */		
		public function toEditMode():void
		{
			
		}
		
		/**
		 */		
		public function toSelectMode():void
		{
			
		}
		
		/**
		 */		
		public function toUnSelectedMode():void
		{
			
		}
		
		/**
		 */		
		public function toPrevMode():void
		{
			
		}
		
		/**
		 * 按下了非选择状态的元件， 取消选择状态
		 */		
		public function unSelectElementDown(element:ElementBase):void
		{
			
		}
		
		/**
		 */		
		public function unSelectElementClicked(element:ElementBase):void
		{
			
		}
		
		/**
		 * 点击了画布背景
		 */		
		public function stageBGClicked():void
		{
			
		}
		
		/**
		 * 吧所有元素切换到预览状态
		 */		
		public function prevElements():void
		{
			var elements:Vector.<ElementBase> = CoreFacade.coreProxy.elements;
			var elementItem:ElementBase;
			for each (elementItem in elements)
				elementItem.toPrevState();
		}
		
		/**
		 */		
		public function returnFromPrevState():void
		{
			var elements:Vector.<ElementBase> = CoreFacade.coreProxy.elements;
			var elementItem:ElementBase;
			for each (elementItem in elements)
				elementItem.returnFromPrevState();
		}
		
		/**
		 */		
		protected var mainMediator:CoreMediator;
	}
}