package view.editor.text
{
	import com.kvs.utils.RexUtil;
	
	import commands.Command;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import model.vo.TextVO;
	
	import util.LayoutUtil;
	
	import view.editor.EditorBase;
	import view.element.text.TextEditField;
	import view.interact.CoreMediator;
	
	/**
	 * 文本编辑器
	 */	
	public class TextEditor extends EditorBase
	{
		/**
		 */		
		public static function get instance():TextEditor
		{
			if (_instance == null)
				_instance = new TextEditor(new Key);
			
			return _instance;
		}
		
		/**
		 */		
		override protected function hide():void
		{
			super.hide();
			
			//如果颜色面板开启，隐藏颜色面板；
			stylePanel.clicked();
		}
		
		/**
		 */		
		private static var _instance:TextEditor;
		
		/**
		 */		
		public function TextEditor(key:Key)
		{
			initTextField();
			
			super();
			
		}
		
		/**
		 * 画布缩放移动时同步更新编辑器位置尺寸
		 */		
		override public function updateLayout():void
		{
			synTextLabelToEditor(textVOProxy);
			textScale.update();
			
			// 画布移动过程中，文本焦点恒定
			textField.setFocus();
		}
		
		/**
		 * 假定textVO， 为文本样式初始化，新创建文本与画布的同步
		 * 
		 * 提供辅助, 因为此事并没有真正的文本被创建
		 */		
		internal var textVOProxy:TextVO = new TextVO;
		
		
		
		
		
		
		//--------------------------------------------------
		//
		//
		//  提供尺寸信息辅助文本边框的绘制
		//
		//
		//--------------------------------------------------
		
		/**
		 */		
		internal function get fieldScale():Number
		{
			return textField.scaleX;
		}
		
		/**
		 */		
		public function get fieldWidth():Number
		{
			return textField.textWidth * textField.scaleX;
		}
		
		/**
		 */		
		public function get fieldHeight():Number
		{
			return textField.textHeight * textField.scaleY;
		}
		
		/**
		 */		
		public function set fieldWidth(value:Number):void
		{
			textField.textWidth = value / textField.scaleX;
		}
		
		public function get panelHeight():Number
		{
			return stylePanel.panelHeight;
		}
		
		public function get panelWidth():Number
		{
			return stylePanel.panelWidth;
		}
		
		/**
		 * 边框与文本框之间的间距 
		 */		
		public var offSet:uint = 12;
		
		
		public function get editorBound():Rectangle
		{
			return new Rectangle(x - offSet, y - offSet - stylePanel.panelHeight, stylePanel.panelWidth, stylePanel.panelHeight + textScale.holderHeight);
		}
		
		
		
		
		//------------------------------------------------------
		//
		//
		//  文本创建与编辑过程中，编辑器与文本元素之间同步切换
		//
		//
		//-------------------------------------------------------
		
		/**
		 * 元件创建时编辑器的位置，layoutRect代表了预设位置， 编辑器根据此
		 * 
		 * 确定最终位置
		 */		
		override protected function layoutAfterCreate():void
		{
			this.x = layoutRect.x;
			this.y = layoutRect.y;
			
			synTextProxy();
			
			textField.reset();
			textField.setFocusForCreate();
			
			textScale.update();
		}
		
		/**
		 */		
		override public function createElement():void
		{
			if (RexUtil.ifHasText(textField.text))
			{
				var textVO:TextVO = new TextVO;
				synEditorToTextLabel(textVO);
				
				mainUIMediator.sendNotification(Command.CREATE_TEXT, textVO);
			}
			
			textField.reset();
			textField.deactivit();
			textScale.hide();
			
		}
		
		/**
		 * 编辑元件时，编辑器根据元件布局信息，调整位置；
		 */		
		override protected function layoutBeforeEdit():void
		{
			var textVO:TextVO = editMode.element.vo as TextVO;
			stylePanel.setStyle(textVO);
			
			//现将文本模型映射到文本编辑器上，再将
			//编辑器模型映射到代理模型上
			//画布缩放和移动会用到代理模型
			synTextLabelToEditor(textVO);
			synTextProxy();
			
			textField.setFocusForEdit();
			textScale.rotation = textVO.rotation + layoutTransformer.canvas.rotation;
			textScale.update();
		}
		
		/**
		 * 更新编辑后的元件
		 */		
		override public function updateElementAfterEdit():void
		{
			if (RexUtil.ifHasText(textField.text))
			{
				synEditorToTextLabel(editMode.element.vo as TextVO);
				
				var field:TextEditField = editMode.element as TextEditField;
				
				field.render();
				field.checkTextBm(true);
			}
			else 
			{
				// 删除无效文本
				mainUIMediator.sendNotification(Command.DELETE_TEXT, editMode.element);
			}
			
			editMode.element = null;
			textField.reset();
			textField.deactivit();
			textScale.hide();
		}
		
		internal function updateAfterInput():void
		{
			if (mainUIMediator)
			{
				mainUIMediator.autofitController.autofitEditorInputText(1, 1);
			}
		}
		
		/**
		 * 将编辑器的状态同步至代理模型上
		 * 
		 * 这样画布缩放和移动时就可以反向同步到文本编辑器
		 */		
		internal function synTextProxy():void
		{
			synEditorToTextLabel(textVOProxy);
		}
		
		/**
		 * 将编辑文本的样式，位置，比例等属性映射到文本模型上，
		 * 
		 * 保证两者视觉效果统一
		 */		
		internal function synEditorToTextLabel(textVO:TextVO):void
		{
			stylePanel.getStyle(textVO);
			
			textVO.rotation = textField.rotation - layoutTransformer.canvas.rotation;
			textVO.scale = layoutTransformer.getElementScaleByStageScale(textField.scaleX);
			
			caculateInfoForRoteTransform(textVO, textVO.scale);
			
			var temp:Point = LayoutUtil.stagePointToElementPoint(x, y, layoutTransformer.canvas);
			
			textVO.x = temp.x - r * Math.cos(rad);
			textVO.y = temp.y - r * Math.sin(rad);
		}
		
		/**
		 * 将文本编辑器的布局与画布中的文本同步
		 */		
		private function synTextLabelToEditor(textVO:TextVO):void
		{
			textField.rotation = textVO.rotation + layoutTransformer.canvas.rotation;
			textField.scaleX = textField.scaleY = layoutTransformer.getStageScaleFromElement(textVO.scale);
			
			caculateInfoForRoteTransform(textVO, textField.scaleX, true);
			
			var point:Point = LayoutUtil.elementPointToStagePoint(textVO.x, textVO.y, layoutTransformer.canvas);
			
			this.x = point.x + r * Math.cos(rad);
			this.y = point.y + r * Math.sin(rad);
		}
		
		
		/**
		 * 为编辑器与文本元件间旋转角度换算准备好辅助信息， 角度, 半径
		 */		
		private function caculateInfoForRoteTransform(textVO:TextVO, scale:Number, canvasRotate:Boolean = false):void
		{
			var w:Number = textVO.width / 2 * scale;
			var h:Number = textVO.height / 2 * scale;
			
			r = Math.sqrt(w * w + h * h);
			rad = (textVO.rotation + ((canvasRotate) ? layoutTransformer.canvas.rotation : 0)) * Math.PI / 180 + Math.PI + Math.atan(h / w);
		}
		
		/**
		 * 文本编辑框坐标点到中心点距离连线旋转角度
		 */		
		private var r:Number = 0;
		
		/**
		 * 文本编辑框坐标点与中心点的连线
		 */		
		private var rad:Number = 0;
		
		
		
		
		
		
		//------------------------------------------------------
		//
		//
		// 文本编辑框
		//
		//
		//------------------------------------------------------
		
		
		private function initTextField():void
		{
			textField = new TextFieldForEditor(this);
			addChild(textField);	
			
			textScale = new TextScaleHolder(this);
			addChild(textScale);
			
			stylePanel = new TextStylePanel(this);
			addChild(stylePanel);
		}
		
		/**
		 * 初始化文本样式
		 */		
		public function initStyle():void
		{
			stylePanel.styleBtnsInit();
		}
		
		/**
		 */		
		internal var stylePanel:TextStylePanel;
		
		/**
		 */		
		internal var textScale:TextScaleHolder;
		
		/**
		 */		
		internal var textField:TextFieldForEditor;
		
		/**
		 */		
		private var _mainUIMediator:CoreMediator;
		
		/**
		 */
		public function get mainUIMediator():CoreMediator
		{
			return _mainUIMediator;
		}
		
		/**
		 * @private
		 */
		public function set mainUIMediator(value:CoreMediator):void
		{
			_mainUIMediator = value;
		}
		
	}
}

class Key
{
	public function Key()
	{
		
	}
}

