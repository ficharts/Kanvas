package view.interact.multiSelect
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	
	import commands.Command;
	
	import flash.events.MouseEvent;
	
	import model.CoreProxy;
	import model.vo.ElementVO;
	
	import util.StyleUtil;
	
	import view.element.ElementBase;
	import view.element.ElementEvent;
	import view.elementSelector.toolBar.ToolBarController;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 * 临时组合
	 */	
	public class TemGroupElement extends ElementBase 
	{
		public function TemGroupElement(multiSelectControl:MultiSelectControl)
		{
			super(new ElementVO);
			
			vo.styleID = 'tem';
			vo.styleType = 'group';
			
			control = multiSelectControl;
		}
		
		override public function toShotcut(renderable:Boolean=false):void
		{
			super.toShotcut(renderable);
			graphics.clear();
		}
		
		override public function toPreview(renderable:Boolean=false):void
		{
			super.toPreview(renderable);
			StyleManager.drawRect(this, vo.style, vo);
		}
		
		/**
		 * 复制出一个新的自己, 同时替换之前的临时组合，
		 */		
		override public function clone():ElementBase
		{
			var newGroup:TemGroupElement = new TemGroupElement(control);
			cloneVO(newGroup.vo);
			
			return newGroup;
		}
		
		/**
		 */		
		override public function copy():void
		{
			control.coreMdt.sendNotification(Command.COPY_TEM_GROUP);
		}
		
		/**
		 */		
		override public function paste():void
		{
			control.coreMdt.sendNotification(Command.PASTE_TEM_GROUP);
		}
		
		/**
		 * 
		 */		
		override protected function mouseUpHandler(evt:MouseEvent):void
		{
			control.temGroupUp();
		}
		
		/**
		 */
		override protected function mouseOverHandler(evt:MouseEvent):void
		{
		}
		
		/**
		 */
		override protected function mouseOutHandler(evt:MouseEvent):void
		{
		}
		
		/**
		 */		
		override protected function initState():void
		{
			
		}
		
		/**
		 */		
		override public function toSelectedState():void
		{
		}
		
		/**
		 */		
		override public function toUnSelectedState():void
		{
			control.clear();
		}
		
		/**
		 */		
		private var control:MultiSelectControl;
		
		/**
		 */		
		override public function showToolBar(toolbar:ToolBarController):void
		{
			toolbar.setCurToolBar(toolbar.temGroup);
		}
		
		/**
		 */		
		override public function startMove():void
		{
			dispatchEvent(new ElementEvent(ElementEvent.START_MOVE, this))
		}
		
		/**
		 */		
		override public function stopMove():void
		{
			dispatchEvent(new ElementEvent(ElementEvent.STOP_MOVE, this));
		}
		
		/**
		 */		
		override protected function mouseDownHandler(evt:MouseEvent):void
		{
			control.temGroupDown();
		}
		
		/**
		 */		
		override public function clicked():void
		{
			
		}
		
		/**
		 */		
		override public function del():void
		{
			control.del();
		}
		
		/**
		 * 重设布局信息
		 */		
		public function rest(width:Number, height:Number, x:Number, y:Number):void
		{
			vo.scale = 1;
			
			vo.x = x;
			vo.y = y;
			
			vo.width = width;
			vo.height = height;
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			super.render();
			
			StyleUtil.applyStyleToElement(vo); 
			
			graphics.clear();
			
			// 中心点为注册点
			vo.style.tx = - vo.width  / 2;
			vo.style.ty = - vo.height / 2;
			
			vo.style.width  = vo.width;
			vo.style.height = vo.height;
			
			StyleManager.drawRect(this, vo.style, vo);
		}
			
		/**
		 * 初始化
		 */
		override protected function init():void
		{
			preRender();
			render();
		}
	}
}