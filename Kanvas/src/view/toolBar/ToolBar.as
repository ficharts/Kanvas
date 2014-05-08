package view.toolBar
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import control.InteractEvent;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;

	/**
	 * 工具条
	 */	
	public class ToolBar extends FiUI
	{
		public function ToolBar()
		{
			super();
		}
		
		/**
		 */		
		public function toPageEditMode():void
		{
			currentState.toPageEdit();
		}
		
		/**
		 */		
		public function toNormalMode():void
		{
			currentState.toNomal();
		}
		
		/**
		 * 初始化
		 */		
		override protected function init():void
		{
			super.init();
			
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
			addChild(bgShape);
			
			normalState = new NormalState(this);
			normalState.init();
			normalState.updateLayout();
			
			pageEditState = new PageEditState(this);
			pageEditState.init();
			pageEditState.updateLayout();	
			
			currentState = normalState;
		}
		
		/**
		 */		
		public function updateLayout():void
		{
			currentState.updateLayout();
		}
		
		/**
		 */		
		public function addCustomButtons(btns:Vector.<IconBtn>):void
		{
			currentState.addCustomButtons(btns);
		}
		
		/**
		 */		
		internal function renderBG():void
		{
			bgShape.graphics.clear();
			
			bgStyle.width = w;
			bgStyle.height = h + 50;
			bgStyle.ty = - 50;
			StyleManager.drawRectOnShape(bgShape, bgStyle);
		}
		
		/**
		 */		
		internal var currentState:ToolBarStateBS;
		
		internal var normalState:ToolBarStateBS;
		
		internal var pageEditState:ToolBarStateBS;
		
		
		
		/**
		 * 绘制背景的画布
		 */		
		internal var bgShape:Shape = new Shape;
		
		/**
		 * 撤销按钮
		 */		
		public function get undoBtn():IconBtn
		{
			return (normalState as NormalState).undoBtn;
		}
		
		/**
		 * 反撤销按钮
		 */	
		public function get  redoBtn():IconBtn{
			return (normalState as NormalState).redoBtn;
		}
		/**
		 * 元素创建按钮，点击后会弹出元素创建面板 
		 */		
		public function get addBtn():IconBtn {
			return (normalState as NormalState).addBtn;
		}
		
		/**
		 * 风格设置按钮，点击后会弹出风格设置面板，用于设置风格和背景； 
		 */		
		public function get themeBtn():IconBtn{
			return (normalState as NormalState).themeBtn;
		}
		
		
		//---------------------------------------------------
		//
		//
		//  背景， 按钮等所需的样式文件
		//
		//
		//---------------------------------------------------
		
		/**
		 * 背景样式
		 */		
		internal var bgStyle:Style = new Style;
		
		/*
		 * 背景样式 的配置文件
		 */		
		internal var bgStyleXML:XML = <style>
											<border thickness='1' alpha='0.8' color='#000000'/>
											<fill color='111111, #1c1d1e' alpha='0.8, 0.8' angle='90'/>
									 </style>
	}
}