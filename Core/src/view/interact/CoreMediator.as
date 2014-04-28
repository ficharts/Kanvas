package view.interact
{
	import commands.Command;
	
	import consts.ConstsTip;
	
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import model.CoreFacade;
	import model.vo.ElementVO;
	import model.vo.PageVO;
	
	import modules.pages.PageManager;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import util.layout.LayoutTransformer;
	
	import view.editor.EditorBase;
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.element.PageElement;
	import view.element.imgElement.ImgElement;
	import view.element.text.TextEditField;
	import view.elementSelector.ElementSelector;
	import view.interact.autoGroup.AutoGroupController;
	import view.interact.interactMode.*;
	import view.interact.keyboard.*;
	import view.interact.multiSelect.MultiSelectControl;
	import view.interact.multiSelect.TemGroupElement;
	import view.interact.zoomMove.ZoomMoveControl;
	import view.ui.Bubble;
	import view.ui.Canvas;
	import view.ui.IMainUIMediator;
	import view.ui.MainUIBase;
	
	/**
	 * 核心core整体的UI控制器
	 * 
	 * 负责整体的鼠标交互控制：画布缩放，平移画布，选择图形，释放图形，移动图形等的总体控制
	 */	
	public class CoreMediator extends Mediator implements IMainUIMediator
	{
		public function CoreMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
			
			coreApp.textEditor.mainUIMediator = this;
		}
		
		/**
		 */		
		public function setPageIndex(value:int):void
		{
			pageManager.index = value;
		}
		
		/**
		 */		
		public function zoomElement(elementVO:ElementVO):void
		{
			zoomMoveControl.zoomElement(elementVO);
		}
		
		/**
		 * 组合智能组合仅包含其自身的子元素
		 * 
		 * 一般元件的智能组合才是默认只能组合机制
		 */		
		public function checkAutoGroup(element:ElementBase):void
		{
			if (element is GroupElement)
			{
				var group:Vector.<ElementBase> = new Vector.<ElementBase>;
				var elements:Vector.<ElementBase> = (element as GroupElement).childElements;
				for each (var child:ElementBase in elements)
				group = child.getChilds(group);
				
				autoGroupController.setGroupElements(group);
			}
			else if (element is TemGroupElement)
			{
				multiSelectControl.autoTemGroup();
			}
			else
			{
				autoGroupController.checkGroup(element);
			}
		}
		
		
		
		
		
		//----------------------------------------------------
		//
		//
		//
		// 原件的添加与删除
		//
		//
		//
		//---------------------------------------------------
		
		/**
		 * 在目标位置加入页面
		 */		
		public function addPage(index:uint):void
		{
			currentMode.addPage(index);
		}
		
		/**
		 * 添加原件到画布上
		 */		
		public function addElement(element:ElementBase):void
		{
			canvas.addChild(element);
		}
		
		public function addElementAt(element:ElementBase, index:int):void
		{
			canvas.addChildAt(element, index);
		}
		
		/**
		 * 删除当前选中的元件, 具体的删除指令由元件自己发出
		 * 
		 * 不同元件对应的指令不同
		 */		
		public function del():void
		{
			// 仅当选择模式下才生效
			currentMode.del();
		}
		
		/**
		 */		
		public function removeElementFromView(element:ElementBase):void
		{
			if (canvas.contains(element))
				canvas.removeChild(element);
		}
		
		public function getElementIndex(element:ElementBase):int
		{
			return canvas.getChildIndex(element);
		}
		
		/**
		 * 清除画布内所有元素
		 */
		public function clearElements():void
		{
			while (canvas.numChildren)
				canvas.removeChildAt(0);
		}
		
		/**
		 */		
		public function copy():void
		{
			currentMode.copy();
		}
		
		/**
		 */		
		public function cut():void
		{
			currentMode.cut();
		}
		
		/**
		 */		
		public function paste():void
		{
			currentMode.paste();
		}
		
		/**
		 */		
		public function undo():void
		{
			currentMode.undo();
		}
		
		public function redo():void
		{
			currentMode.redo();
		}
		
		/**
		 */		
		public function esc():void
		{
			currentMode.esc();
		}
		
		public function moveOff(xOff:Number, yOff:Number):void
		{
			currentMode.moveOff(xOff, yOff);
		}
		
		/**
		 */		
		public function selectAll():void
		{
			currentMode.selectAll();
		}
		
		/**
		 */		
		public function autoZoom():void
		{
			sendNotification(Command.AUTO_ZOOM);
		}
		
		/**
		 * 组合
		 */		
		public function group():void
		{
			currentMode.group();
		}
		
		/**
		 * 解除组合
		 */		
		public function unGroup():void
		{
			currentMode.unGroup();
		}
		
		
		
		
		
		
		
		
		//---------------------------------------------------
		//
		// 
		// 编辑面板控制
		//
		//
		//---------------------------------------------------
		
		/**
		 * 设置当前原件编辑器为文本编辑器 
		 */		
		public function setEditorASText():void
		{
			setEditor(coreApp.textEditor);
		}
		
		/**
		 * 切换编辑器， 在创建或者编辑具有编辑状态的复杂原件时
		 * 
		 * 先切换到合适的编辑器，然后再创建或者编辑原件
		 */		
		public function setEditor(editor:EditorBase):void
		{
			currentEditor = editor;
		}
		
		/**
		 * 准备创建可编辑的原件
		 * 
		 * @rect， 原件的位置尺寸信息，相对于stage
		 */		
		public function willCreateElement(rect:Rectangle):void
		{
			currentEditor.willCreate(rect);
			toEditMode();
		}
		
		/**
		 * 编辑原件
		 */		
		public function editElement(element:ElementBase):void
		{
			coreApp.textEditor.edit(element);
			CoreFacade.coreMediator.autofitController.autofitEditorModifyText(element);
			toEditMode();
		}
		
		/**
		 * 应用从编辑状态进入非选择状态时，关闭编辑器
		 * 
		 * 由编辑器决定创建或者更新原件
		 */		
		public function closeEditor():void
		{
			currentEditor.close();
		}
		
		
		
		/**
		 */		
		public var currentEditor:EditorBase;
		
		
		
		
		
		
		
		
		//----------------------------------------------
		//
		//
		// 选择状态的切换, 鼠标交互的控制
		//
		//
		//----------------------------------------------
		
		
		
		
		/**
		 * 进入到选择模式，当前场景中有图形被选择；
		 * 
		 * 开启型变框
		 */		
		public function toSelectedMode():void
		{
			currentMode.toSelectMode();
		}
		
		/**
		 * 进入到非选择模式，当前场景中没有任何图形被选择
		 * 
		 * 关闭型变框
		 */		
		public function toUnSelectedMode():void
		{
			currentMode.toUnSelectedMode();
		}
		
		/**
		 */		
		public function toPrevMode():void
		{
			//现将当前状态调整到非选择状态，仅从非选择状态才可以到达预览状态
			//推出预览状态，则回到非选择状态
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			currentMode.toPrevMode();
		}
		
		/**
		 * 进入编辑状态，关闭键盘全局相应，关闭型变框
		 */		
		public function toEditMode():void
		{
			currentMode.toEditMode();
		}
		
		/**
		 * 开始型变控制框，元素被选择后续执行的动作
		 */		
		public function openSelector():void
		{
			currentMode.showSelector();
		}
		
		/**
		 * 关闭型变控制框，取消选择元素后/元件进入编辑状态（如，
		 * 
		 * 文本框的编辑状态下是不显示型变框的）
		 */		
		public function showSelector():void
		{
			currentMode.hideSelector();
		}
		
		/**
		 * 拖动原件时，同步移动选择器
		 */		
		public function moveSelector(x:Number, y:Number):void
		{
			currentMode.moveSelector(x, y);
		}
		
		/**
		 * 缩放移动画布时，更新选择框的尺寸位置
		 */		
		public function updateSelector():void
		{
			selector.update();
		}
		
		
		
		
		
		
		
		//---------------------------------------------------
		//
		//
		//
		// 各种常用到的控制器
		//
		//
		//
		//----------------------------------------------------
		
		
		/**
		 */		
		private var _isMulitySelectingMode:Boolean = false;
		
		/**
		 * 多选模式，但用户按下control/shift/alt键触发, 释放按键
		 * 
		 * 关闭, 这回影响到选择模式中的具体行为
		 */
		public function get isMulitySelectingMode():Boolean
		{
			return _isMulitySelectingMode;
		}
		
		/**
		 * @private
		 */
		public function set isMulitySelectingMode(value:Boolean):void
		{
			//画布正在拖动时，状态变更指令无效
			if (zoomMoveControl.isMoving)
				return;
			
			if (_isMulitySelectingMode == value) return;
			
			_isMulitySelectingMode = value;
			
			if (_isMulitySelectingMode)
			{
				Bubble.show(ConstsTip.TIP_TO_MULTI_STATE);
				multiSelectControl.toMultiState();
			}
			else
			{
				Bubble.show(ConstsTip.TIP_TO_NORMAL_STATE);
				multiSelectControl.toNomalState();
			}
		}
		
		/**
		 * 多选控制器，总共有两种选择模式：单选模式和多选模式
		 * 
		 * 选择相关交互先经由multiSelectControl，再分发到currentMode;
		 */		
		public var multiSelectControl:MultiSelectControl;
		
		/**
		 * 编辑状态：非选择，选择，编辑
		 */		
		public var currentMode:ModeBase;
		public var selectedMode:ModeBase;
		public var unSelectedMode:ModeBase;
		public var preMode:ModeBase;
		public var editMode:ModeBase;
		
		/**
		 * 图形元素 选择，拖动，取消选择等交互行为控制
		 */		
		private var elementsInteractControl:ElementsInteractor;
		
		/**
		 * 画布缩放移动控制器
		 */	
		public var zoomMoveControl:ZoomMoveControl;
		
		/**
		 * 预览时鼠标点击控制 
		 */		
		public var previewCliker:PreviewClicker;
		
		/**
		 * 元素移动控制器
		 */		
		public var elementMoveController:ElementMoveController;
		
		/**
		 * 智能组合控制器
		 */		
		public var autoGroupController:AutoGroupController;
		
		/**
		 * 碰撞检测控制器
		 */		
		public var collisionDetection:ElementCollisionDetection;
		
		public var autoAlignController:ElementAutoAlignController;
		
		public var autofitController:ElementAutofitController;
		
		public var autoLayerController:ElementAutoLayerController;
		
		public var pageManager:PageManager;
		
		/**
		 * 属性控制器 , 快捷属性编辑, 工具条，型变控制都由其负责
		 */		
		public var selector:ElementSelector;
		
		public var mouseDown:Boolean;
		
		
		
		
		
		
		
		
		//------------------------------------------------------------
		//
		//
		//
		// 初始化及交互事件的监听
		//
		//
		//------------------------------------------------------------
		
		/**
		 */		
		override public function onRegister():void
		{
			zoomMoveControl = new ZoomMoveControl(this);
			previewCliker = new PreviewClicker(this);
			elementsInteractControl = new ElementsInteractor(coreApp, this);
			elementMoveController = new ElementMoveController(this);
			autoGroupController = new AutoGroupController(this);
			
			selector = new ElementSelector(this);
			coreApp.addChild(selector);
			
			//多选控制器
			multiSelectControl = new MultiSelectControl(this);
			
			//状态
			selectedMode = new SelectedMode(this);
			unSelectedMode = new UnSelectedMode(this);
			editMode = new EditMode(this);
			preMode = new PrevMode(this);
			
			currentMode = unSelectedMode;
			
			// 划入core的主场景后滚轮监听才生效，防止干扰主UI上的滚轮交互；
			coreApp.addEventListener(MouseEvent.ROLL_OUT, outKanvas);
			coreApp.addEventListener(MouseEvent.ROLL_OVER, overKanvas);
			
			// 键盘按键是全局式响应
			enableKeyboardState = new EnableKeyboardSate(this);
			disKeyboardState = new DisKeyboardState(this);
			currentKeyboardState = enableKeyboardState;
			
			coreApp.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, true);
			coreApp.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
			coreApp.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpBoardHandler, false, 0, true);
			coreApp.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownBoardHandler, false, 0, true);
			
			// 元件碰撞检测，从而控制智能组合，大元件不可以被拖动和超出场景外元素的隐藏
			collisionDetection = new ElementCollisionDetection(this, CoreFacade.coreProxy.elements, coreApp.externalUI);
			
			//声明自动对其控制器，用于检测移动，缩放，旋转时的自动对其功能
			autoAlignController = new ElementAutoAlignController(CoreFacade.coreProxy.elements, coreApp.canvas, coreApp.autoAlignUI, this);
			
			//检测元素与场景的关系，如果超出尺寸范围则缩放与移动至画布中央
			autofitController = new ElementAutofitController(this);
			
			//层级自动控制
			autoLayerController = new ElementAutoLayerController(this);
			
			//镜头绘制
			cameraShotShape.visible = false;
			coreApp.addChild(cameraShotShape);
			currentMode.drawShotFrame();
			coreApp.addEventListener(KVSEvent.UPATE_BOUND, renderBoundHandler);
			
			pageManager = new PageManager(this);
		}
		
		/**
		 * 鼠标滑入kanvas核心
		 */
		private function overKanvas(event:MouseEvent):void
		{
			// 添加画布滚动缩放监听
			coreApp.stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler, false, 0, true);
		}
		
		/**
		 * 鼠标滑出kanvas核心
		 */
		private function outKanvas(event:MouseEvent):void
		{
			coreApp.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}
		
		/**
		 * 鼠标混动事件处理, 控制整体缩放
		 */
		private function mouseWheelHandler(evt:MouseEvent):void
		{
			if (evt.delta > 0)
				zoomMoveControl.zoomIn();
			else
				zoomMoveControl.zoomOut();
		}
		
		private function mouseDownHandler(evt:MouseEvent):void
		{
			mouseDown = true;
		}
		
		private function mouseUpHandler(evt:MouseEvent):void
		{
			mouseDown = false;
		}
		
		/**
		 *键盘按下事件处理 
		 */
		private function keyDownBoardHandler(evt:KeyboardEvent):void
		{
			currentKeyboardState.keyDownBoardHandler(evt);
		}
		
		/**
		 *键盘弹起事件处理 
		 */
		private function keyUpBoardHandler(evt:KeyboardEvent):void
		{
			currentKeyboardState.keyUpBoardHandler(evt);
		}
		
		/**
		 * 生效键盘控制
		 */		
		public function enableKeyboardControl():void
		{
			currentKeyboardState.toEnableState();
		}
		
		/**
		 * 实效键盘控制
		 */		
		public function disableKeyboardControl():void
		{
			currentKeyboardState.toDisableState();
		}
		
		/**
		 * 键盘事件全局生效状态
		 */
		public var enableKeyboardState:EnableKeyboardSate;
		
		/**
		 * 全局不响应键盘事件
		 */
		public var disKeyboardState:DisKeyboardState;
		
		/**
		 *当前键盘状态 
		 */
		public var currentKeyboardState:KeyboardStateBase;
		
		
		
		
		
		
		
		
		
		//-----------------------------------------
		//
		//
		// 画布缩放控制
		//
		//
		//------------------------------------------
		
		
		/**
		 * 放大画布
		 */
		public function zoomIn(multiple:Number = 1.2):void
		{
			zoomMoveControl.zoomIn();
			coreApp.updatePastPoint();
		}
		
		/**
		 * 缩小画布
		 */
		public function zoomOut(multiple:Number = 1.2):void
		{
			zoomMoveControl.zoomOut();
			coreApp.updatePastPoint();
		}
		
		/**
		 * 自适应
		 */
		public function zoomAuto():void
		{
			zoomMoveControl.zoomAuto();
			coreApp.updatePastPoint();
		}
		
		/**
		 * 改变画布背景颜色
		 */
		public function renderBGWidthColor(color:uint):void
		{
			coreApp.renderBGWithColor(color);
		}
		
		/**
		 */		
		public function flashPlay():void
		{
			var elements:Vector.<ElementBase> = CoreFacade.coreProxy.elements;
			for each (var element:ElementBase in elements)
			{
				if (element is ImgElement)
				{
					(element as ImgElement).smooth = false;
				}
				else if (element is TextEditField)
				{
					(element as TextEditField).smooth = false;
				}
			}
		}
		
		/**
		 */		
		public function flashTrek():void
		{
			if (currentMode != preMode) 
			{
				currentMode.updateSelector();
				collisionDetection.updateAfterZoomMove();
				
				coreApp.updatePastPoint();
			}
		
			
			//检测，重绘文本， 以达到像素精度不失真
			//PerformaceTest.start("CoreMediator.flashTrek()")
			var elements:Vector.<ElementBase> = CoreFacade.coreProxy.elements;
			for each (var element:ElementBase in elements)
			{
				if (element.visible)
				{
					if (element is TextEditField)
					{
						(element as TextEditField).checkTextBm();
					}
					//刷新页面编号尺寸，防止太大
					else if (element.isPage)
					{
						element.layoutPageNum();
					}
				}
			}
			//PerformaceTest.end("CoreMediator.flashTrek()")
			//mainUI.drawBgInteractorShape();
			
		}
		
		/**
		 */		
		public function flashStop():void
		{
			var elements:Vector.<ElementBase> = CoreFacade.coreProxy.elements;
			for each (var element:ElementBase in elements)
			{
				if (element is ImgElement)
				{
					(element as ImgElement).smooth = true;
				}
				else if (element is TextEditField)
				{
					(element as TextEditField).smooth = true;
				}
			}
		}
		
		/**
		 */		
		public function bgClicked():void
		{
			multiSelectControl.stageBGClicked();
		}
		
		
		
		//-----------------------------------------------
		//
		//
		// 镜头焦距的显示与绘制
		// 
		//
		//
		//-------------------------------------------------
		
		/**
		 */		
		public function showCameraShot():void
		{
			coreApp.stage.addEventListener(Event.ENTER_FRAME, shotFlash);
			
			cameraShotShape.alpha = 0;
			cameraShotShape.visible = true;
		}
		
		/**
		 */		
		public function hideCanmeraShot():void
		{
			coreApp.stage.removeEventListener(Event.ENTER_FRAME, shotFlash);
			
			cameraShotShape.visible = false;
			cameraShotShape.alpha = 0;
		}
		
		/**
		 */		
		private function shotFlash(evt:Event):void
		{
			if (cameraShotShape.alpha >= 1)
			{
				cameraShotShape.alpha = 1;
				adder = - 0.05;
			}
			else if (cameraShotShape.alpha <= 0)
			{
				cameraShotShape.alpha = 0;
				adder = 0.05;
			}
			
			cameraShotShape.alpha += adder;
		}
		
		/**
		 */		
		private var adder:Number = 0.1;
		
		/**
		 */		
		private function renderBoundHandler(evt:KVSEvent):void
		{
			currentMode.drawShotFrame();
		}
		
		/**
		 */		
		public function drawShotFrame(bound:Rectangle, rotation:Number = 0):void
		{
			var len:uint = 10;
			
			cameraShotShape.x = (bound.left + bound.right) * .5;
			cameraShotShape.y = (bound.top + bound.bottom) * .5;
			cameraShotShape.rotation = rotation;
			
			var w:Number = bound.width;
			var h:Number = bound.height;
			var cw:Number = bound.width * .5;
			var ch:Number = bound.height * .5;
			
			cameraShotShape.graphics.clear();
			cameraShotShape.graphics.lineStyle(8, 0, 0.6, false, 'none', 'square');
			
			//左上角
			cameraShotShape.graphics.moveTo(- cw, - ch + len);
			cameraShotShape.graphics.lineTo(- cw, - ch);
			cameraShotShape.graphics.lineTo(- cw + len, - ch);
			
			//右上角
			cameraShotShape.graphics.moveTo(cw, - ch + len);
			cameraShotShape.graphics.lineTo(cw, - ch);
			cameraShotShape.graphics.lineTo(cw - len, - ch);
			
			//右下角
			cameraShotShape.graphics.moveTo(cw, ch - len);
			cameraShotShape.graphics.lineTo(cw, ch);
			cameraShotShape.graphics.lineTo(cw - len, ch);
			
			//左下角
			cameraShotShape.graphics.moveTo(- cw, ch - len);
			cameraShotShape.graphics.lineTo(- cw, ch);
			cameraShotShape.graphics.lineTo(- cw + len, ch);
		}
		
		
		/**
		 * 用来绘制镜头 
		 */		
		public var cameraShotShape:Shape = new Shape;
		
		
		//-----------------------------------------------
		//
		//
		//
		// 常用元素的获取
		//
		//
		//-------------------------------------------------
		
		/**
		 */		
		public function startDragElement():void
		{
			createNewShape = true;
			createNewShapeMouseUped = false;
			autoGroupController.clear();
			elementMoveController.startMove(currentElement);
		}
		
		/**
		 * 一个用于判断是否创建新形状的变量
		 */		
		public var createNewShape:Boolean;
		
		/**
		 * 创建新形状时鼠标是否弹起
		 */
		public var createNewShapeMouseUped:Boolean;
		
		/**
		 * 创建新形状时动画是否播放完毕
		 */
		public var createNewShapeTweenOver:Boolean;
		
		/**
		 */		
		public function endDragElment():void
		{
			elementMoveController.stopMove();
			
			if (currentElement)
			{
				if (currentElement.vo is PageVO)
					var pageVO:PageVO = currentElement.vo as PageVO;
				if (pageVO)
					pageVO.thumbUpdatable = false;
				currentElement.vo.x = currentElement.x;
				currentElement.vo.y = currentElement.y;
				if (pageVO)
				{
					pageVO.thumbUpdatable = true;
					pageManager.notifyPageVOUpdateThumb(pageVO);
				}
				
			}
		}
		
		/**
		 */		
		private var startX:Number;
		private var startY:Number;
		
		
		/**
		 * 画布缩放或者移动后刷新粘帖预设坐标
		 * 
		 * 默认在画布中心
		 */		
		public function updatePastePosition():void
		{
			
		}
		
		/**
		 */		
		public var xForPaste:Number = 0;
		
		/**
		 */		
		public var yForPaste:Number = 0;
		
		/**
		 */		
		public function setElementForPaste():void
		{
			pastElement = currentElement;
		}
		
		/**
		 */		
		public function getElementForPaste():ElementBase
		{
			return pastElement;
		}
		
		/**
		 */		
		private var pastElement:ElementBase;
		
		/**
		 */		
		public function get layoutTransformer():LayoutTransformer
		{
			return coreApp.layoutTransformer;
		}
		
		/**
		 * 得到当前元素
		 */
		public function get currentElement():ElementBase
		{
			return _currentElement;
		}
		
		/**
		 * 设置当前元素, 被clicked了的元件， 此时型变框会伴随其一起出现
		 */
		public function set currentElement(value:ElementBase):void
		{
			_currentElement = value;
		}
		
		/**
		 * 当前元素, 即处于选择状态的元素
		 */
		private var _currentElement:ElementBase;
		
		
		/**
		 * 正在被鼠标交互的元素，例如目前正在被拖动的元素，移动命令中会用到；
		 * 
		 * 被拖动的元素不一定就是当前的Element
		 */
		public function get curInteractElement():ElementBase
		{
			return _curInteractElement;
		}
		
		/**
		 * @private
		 */
		public function set curInteractElement(value:ElementBase):void
		{
			_curInteractElement = value;
		}
		
		/**
		 */		
		private var _curInteractElement:ElementBase;
		
		/**
		 */		
		public function get coreApp():CoreApp
		{
			return viewComponent as CoreApp;
		}
		
		/**
		 */		
		public function get mainUI():MainUIBase
		{
			return viewComponent as MainUIBase
		}
		
		/**
		 */		
		public function get canvas():Canvas
		{
			return coreApp.canvas;
		}
	}
}