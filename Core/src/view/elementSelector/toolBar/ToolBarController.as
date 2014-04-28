	package view.elementSelector.toolBar
{
	import com.kvs.ui.FiUI;
	import com.kvs.ui.button.IconBtn;
	import com.kvs.utils.Map;
	import com.kvs.utils.ViewUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import commands.Command;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import view.elementSelector.ElementSelector;
	
	/**
	 * 快捷工具条主控制类, 不同类型组件有相应的工具条控制器，具体决定工具条内容和行为；
	 */	
	public class ToolBarController extends Sprite
	{
		public function ToolBarController(selector:ElementSelector)
		{
			super();
			
			this.selector = selector;
			
			XMLVOMapper.fuck(bgStyleXML, bgStyle);
			addChild(bg);
			
			addChild(btnsContainer);
			
			initBtns();
			
			fillShape = new FillShape(this);
			borderShape = new BorderShape(this);
			defaultShape = new DefaultShape(this);
			lineShape = new LineShape(this);
			text = new TextShape(this);
			temGroup = new TemGroupToolbar(this);
			group = new GroupToolbar(this);
			wholeShape = new WholeShapeToolBar(this);
			cameraShape = new CameraShape(this);
		}
		
		/**
		 */		
		public function registerToolBar(type:String, TB:Class):void
		{
			toolBarMap.put(type, new TB(this));
		}
		
		/**
		 */		
		public function getToolBar(type:String):ToolBarBase
		{
			return toolBarMap.getValue(type) as ToolBarBase;
		}
		
		/**
		 *  
		 */		
		private var toolBarMap:Map = new Map;
		
		
		
		
		
		
		//------------------------------------------------------
		//
		//
		// 基本控制指令
		//
		//
		//-------------------------------------------------------
			
		/**
		 */		
		private function delHandler(evt:MouseEvent):void
		{
			selector.element.del();
		}
		
		/**
		 * 向上移一层
		 */		
		private function upLayerHandler(evt:MouseEvent):void
		{
			var index:uint = selector.element.index;
			if (index < selector.coreMdt.canvas.numChildren - 1) 
				setLayer(index + 1);
		}
		
		/**
		 * 向下移一层
		 */		
		private function downLayerHandler(evtg:MouseEvent):void
		{
			var index:uint = selector.element.index;
			if (index > 1) 
				setLayer(index - 1);
		}
		
		/**
		 * 双击，最上层
		 */		
		private function topLayer(evt:MouseEvent):void
		{
			var p:DisplayObjectContainer = selector.element.parent;
			var index:uint = selector.element.index;
			if (index < p.numChildren - 1)
				setLayer(p.numChildren - 1);
		}
		
		/**
		 */		
		private function bottomLayer(evt:MouseEvent):void
		{
			var index:uint = selector.element.index;
			if (index > 1)
				setLayer(1);
		}
		
		/**
		 */		
		private function linkHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new KVSEvent(KVSEvent.LINK_CLICKED));
		}
		
		
		private function setLayer(index:int):void
		{
			selector.coreMdt.sendNotification(Command.CHANGE_ELEMENT_LAYER, index);
		}
		
		
		private function convertPageHandler(e:MouseEvent):void
		{
			selector.coreMdt.sendNotification(Command.CONVERT_ELEMENT_2_PAGE, selector.element);
		}
		
		
		private function convertElementHandler(e:MouseEvent):void
		{
			selector.coreMdt.sendNotification(Command.CONVERT_PAGE_2_ELEMENT, selector.element);
		}
		
		
		//----------------------------------------------------
		//
		//
		// 色彩选择器
		//
		//
		//-----------------------------------------------------
		
		/**
		 */		
		private function openColorsSelecterHandler(evt:MouseEvent):void
		{
			//防止颜色选择被触发
			evt.stopImmediatePropagation();
			
			this.clear();
			showColorBtns();
			
			curToolBar.stylePanelOpen();
			
			curStyleBtn.selected = true;
			
			renderBG();
			
			addEventListener(MouseEvent.CLICK, colorSelectHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, previewColorHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, resetColorHandler, false, 0, true);
			
			isColorPanelOpened = true;
		}
		
		/**
		 * 当前所选颜色的颜色按钮， 用于记录和标识当前颜色
		 */		
		public var curStyleBtn:StyleBtn;
		
		/**
		 */		
		private var isColorPanelOpened:Boolean = false;
		
		/**
		 */		
		private function unRegisterColorEditHandlers():void
		{
			if (isColorPanelOpened)
			{
				removeEventListener(MouseEvent.CLICK, colorSelectHandler);
				removeEventListener(MouseEvent.MOUSE_OVER, previewColorHandler);
				removeEventListener(MouseEvent.ROLL_OUT, resetColorHandler);
					
				isColorPanelOpened = false;
			}
		}
		
		/**
		 * 鼠标滑动方式预览颜色效果
		 */		
		private function previewColorHandler(evt:MouseEvent):void
		{
			if (evt.target is StyleBtn)
				curToolBar.prevStyle(evt.target as StyleBtn);
			else//当前样式按钮不触发事件，相当于背景容器Sprite触发mouseover事件
				curToolBar.reBackStyle();
		}
		
		/**
		 * 鼠标滑出颜色面板后，颜色还原
		 */		
		private function resetColorHandler(evt:MouseEvent):void
		{
			curStyleBtn.selected = true;
			
			curToolBar.reBackStyle();
		}
				
		/**
		 */		
		private function colorSelectHandler(evt:MouseEvent):void
		{
			if (evt.target is StyleBtn)
				curToolBar.styleSelected(evt.target as StyleBtn);
		}
		
		/**
		 */		
		private function backColorHandler(evt:MouseEvent):void
		{
			//仅回退时，元件的颜色并未被真正改变
			curToolBar.reBackStyle();
			
			resetToolbar();
		}
		
		/**
		 */		
		public function showColorBtns():void
		{
			var colorBtn:StyleBtn;
			
			addBtn(backBtn);
			
			var btns:Array = colorBtns.values();
			for each(colorBtn in btns)
				this.addBtn(colorBtn);
		}
		
		/**
		 */		
		internal var colorBtns:Map = new Map;
		
		
		
		
		
		
		
		
		
		//--------------------------------------------------
		//
		//
		// 工具条切换
		//
		//
		//---------------------------------------------------
											
		/**
		 * 设置当前元件的的工具条，不同元素控制自己采用那个工具条
		 */		
		public function setCurToolBar(toolbar:ToolBarBase):void
		{
			curToolBar = toolbar;
			curToolBar.init();
			
			resetToolbar();
		}
		
		/**
		 * 将当前工具条复原
		 */		
		public function resetToolbar():void
		{
			clear();
			if (curToolBar)
				curToolBar.render();
			renderBG();
		}
		
		/**
		 */		
		private var curToolBar:ToolBarBase;
		
		/**
		 */		
		public function layout(style:Style):void
		{
			// 线条和图形工具条的布局方式不同
			curToolBar.layout(style);
		}
		
		/**
		 * 填充工具条
		 */		
		public var fillShape:ToolBarBase;
		
		/**
		 * 边框工具条
		 */		
		public var borderShape:ToolBarBase;
		
		/**
		 * 线条工具条
		 */		
		public var lineShape:ToolBarBase;
		
		/**
		 */		
		public var defaultShape:ToolBarBase;
		
		/**
		 * 临时组合的工具条 
		 */		
		public var temGroup:TemGroupToolbar;
		
		/**
		 * 组合的工具条
		 */		
		public var group:GroupToolbar;
		
		/**
		 * 
		 */		
		public var wholeShape:WholeShapeToolBar;
		
		/**
		 * 
		 */	
		public var cameraShape:CameraShape;
		
		/**
		 * 文本工具条
		 */		
		public var text:ToolBarBase;
		
		/**
		 */		
		internal var btnsContainer:Sprite = new Sprite;
		
		/**
		 */		
		public function show():void
		{
			ViewUtil.show(this);
		}
		
		/**
		 */		
		public function hide():void
		{
			ViewUtil.hide(this);
		}
		
		/**
		 * 清空工具条
		 */		
		public function clear():void
		{
			//关闭工具条时，如果颜色选择慢板开启，需注销
			// 颜色相关交互事件
			unRegisterColorEditHandlers();
			
			btnsContainer.graphics.clear();
			
			while(btnsContainer.numChildren)
				btnsContainer.removeChildAt(0);
		}
		
		
		
		
		
		
		
		//--------------------------------------------------
		//
		//
		// 布局与样式配置
		//
		//
		//---------------------------------------------------
		
		/**
		 */		
		public function renderBG():void
		{
			var canvas:Graphics = btnsContainer.graphics;
			canvas.clear();
			
			var pw:Number = barWidth - 1;//工具条的原始宽度
			var ph:Number = barHeight - 1;
			var off:uint = 2;//轮廓的偏移量
			var px:Number = pw / 2;
			
			bgStyle.tx = - off;
			bgStyle.ty = - off;
			bgStyle.width = pw + off * 2;
			bgStyle.height = ph + off * 2;
			bgStyle.radius = 3;
			
			StyleManager.drawRect(btnsContainer, bgStyle);
			
			StyleManager.setShapeStyle(bgStyle, canvas);
		
			canvas.moveTo(px, ph + off + pointOff);
			canvas.lineTo(px - pointOff, ph + off);
			canvas.lineTo(px + pointOff, ph + off);
			canvas.lineTo(px, ph + off + pointOff);
			canvas.endFill();
			
			btnsContainer.x = - bgStyle.width / 2 + off;
			btnsContainer.y = - bgStyle.height - pointOff// + off;
		}
		
		/**
		 * 按照加入btn的先后顺序排列其位置
		 */		
		public function addBtn(btn:FiUI):void
		{
			var num:Number = btnsContainer.numChildren;
			var btnLyoutRow:uint = Math.floor(num/numPerRow);
			
			btnsContainer.addChild(btn);
			
			btn.y = btn.height * btnLyoutRow;	
			btn.x = (num % numPerRow) * btn.width;
		}
		
		/**
		 * 每行按钮的数目 
		 */		
		public var numPerRow:uint = 10;
		
		/**
		 */		
		public function initBtnStyle(btn:IconBtn, icon:String):void
		{
			btn.w = btnWidth;
			btn.h = btnHeight;
			
			if (btn == backBtn)
				btn.iconW = btn.iconH = 25;//回撤按钮大一点，和谐
			else
				btn.iconW = btn.iconH = iconSize;
			
			btn.styleXML = btnBGStyle;
			btn.setIcons(icon, icon, icon);
		}
		
		/**
		 */		
		public function get barWidth():Number
		{
			return btnsContainer.width; 
		}
		
		/**
		 * 工具条的高度
		 */		
		public function get barHeight():Number
		{
			return btnsContainer.height;
		}
		
		
		
		
		
		
		
		
		//--------------------------------------------------
		//
		//
		// 通用按钮
		//
		//
		//---------------------------------------------------
		
		
		private function initBtns():void
		{
			var btnSize:uint = 18;
			
			del;
			link;
			up;
			down;
			cancel;
			
			backBtn.tips = '返回';
			initBtnStyle(backBtn, 'cancel');
			backBtn.addEventListener(MouseEvent.CLICK, backColorHandler, false, 0, true);
			
			delBtn.tips = '删除';
			initBtnStyle(delBtn, 'del');
			delBtn.addEventListener(MouseEvent.CLICK, delHandler, false, 0, true);
			
			linkBtn.tips = '关联知识';
			initBtnStyle(linkBtn, 'link');
			linkBtn.addEventListener(MouseEvent.CLICK, linkHandler, false, 0, true);
			
			topLayerBtn.tips = '上一层，双击移至最上层';
			initBtnStyle(topLayerBtn, 'up');
			
			topLayerBtn.addEventListener(MouseEvent.CLICK, upLayerHandler, false, 0, true);
			topLayerBtn.doubleClickEnabled = true;
			topLayerBtn.addEventListener(MouseEvent.DOUBLE_CLICK, topLayer, false, 0, true);
			
			bottomLayerBtn.tips = '下一层，双击移至最下层';
			initBtnStyle(bottomLayerBtn, 'down');
			
			bottomLayerBtn.addEventListener(MouseEvent.CLICK, downLayerHandler, false, 0, true);
			bottomLayerBtn.doubleClickEnabled = true;
			bottomLayerBtn.addEventListener(MouseEvent.DOUBLE_CLICK, bottomLayer, false, 0, true);
			
			convertPageBtn.tips = "转换为页面";
			initBtnStyle(convertPageBtn, 'link');
			convertPageBtn.addEventListener(MouseEvent.CLICK, convertPageHandler);
			
			convertElementBtn.tips = '转换为元素';
			initBtnStyle(convertElementBtn, 'link');
			convertElementBtn.addEventListener(MouseEvent.CLICK, convertElementHandler);
			
			styleBtn.tips = '颜色/样式';
			this.styleBtn.w = btnWidth;
			this.styleBtn.h = btnHeight;
			this.styleBtn.iconWidth = 22;
			this.styleBtn.iconHeight = 22;
			this.styleBtn.bgStatesXML = btnBGStyle;
			
			this.styleBtn.addEventListener(MouseEvent.CLICK, openColorsSelecterHandler, false, 0, true);
			
		}
		
		/**
		 * 按钮宽度
		 */		
		public var btnWidth:uint = 40;
		
		/**
		 * 按钮高度
		 */		
		public var btnHeight:uint = 40;
		
		/**
		 * 图标大小 
		 */		
		public var iconSize:uint = 16;
		
		/**
		 * 最上层按钮 
		 */		
		public var topLayerBtn:IconBtn = new IconBtn;
		
		/**
		 * 最下层按钮 
		 */		
		public var  bottomLayerBtn:IconBtn = new IconBtn;
		
		/**
		 * 删除按钮 
		 */		
		public var delBtn:IconBtn = new IconBtn;
		
		/**
		 * 关联按钮
		 */		
		public var linkBtn:IconBtn = new IconBtn;
		
		/**
		 */		
		private var backBtn:IconBtn = new IconBtn;
		
		/**
		 * 颜色按钮 
		 */		
		public var styleBtn:StyleBtn = new StyleBtn;
		
		public var convertPageBtn:IconBtn = new IconBtn;
		
		public var convertElementBtn:IconBtn = new IconBtn;
		
		/**
		 * 注册点到工具面板的距离
		 */		
		private var pointOff:uint = 8;
		
		/**
		 */		
		private var bg:Shape = new Shape;
		
		/**
		 */		
		private var bgStyle:Style = new Style;
		
		/**
		 */		
		private var bgStyleXML:XML = <style>
										<!--border thickness='1' color='222222' pixelHinting='true' alpha='1'/-->
										<fill color='000000' alpha='0.6'/>
									</style>
		/**
		 * 按钮背景样式
		 */			
	    public var btnBGStyle:XML = <states>
										<normal>
											<border thickness='1' alpha='1' color='#373737'/>
											<fill color='#6a6a6a, #585858' alpha='1, 1' angle='90'/>
											<img/>
										</normal>
										<hover>
											<border thickness='1' color='000000'/>
											<fill color='#5f5f5f, #505050' alpha='1, 1' angle='90'/>
											<img/>
										</hover>
										<down>
											<border thickness='1' color='000000'/>
											<fill color='#3f3f3f, #303030' alpha='1, 1' angle='90'/>
											<img/>
										</down>
									</states>
			
			
		/**
		 * 按钮label样式
		 */			
		public var btnLabelStyleXML:XML =  <label vAlign="center" paddingBottom='5' paddingTop='0'>
												<format color='#ffffff' font='微软雅黑' size='10' letterSpacing="3"/>
											</label>
		
		/**
		 */		
		public var selector:ElementSelector;
	}
}