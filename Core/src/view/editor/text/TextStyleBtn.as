package view.editor.text
{
	import com.kvs.utils.StageUtil;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.IStyleStatesUI;
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.StatesControl;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	import flashx.textLayout.container.TextContainerManager;
	import flashx.textLayout.edit.EditingMode;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import model.vo.TextVO;
	
	import util.textFlow.FlowTextManager;
	import util.textFlow.ITextFlowLabel;
	
	/**
	 * 字体样式选择按钮
	 */	
	public class TextStyleBtn extends Sprite implements IStyleStatesUI, ITextFlowLabel
	{
		public function TextStyleBtn()
		{
			super();
			
			this.mouseChildren = false;
			StageUtil.initApplication(this, init);
		}
		
		/**
		 */
		public function get text():String
		{
			return textVO.text;
		}

		/**
		 * @private
		 */
		public function set text(value:String):void
		{
			textVO.text = value;
		}
		
		/**
		 */		
		private function init():void
		{
			XMLVOMapper.fuck(bgStyleXML, states);
			statesControl = new StatesControl(this, states);
			
			textCanvas.x = 10;
			textCanvas.y = 5;
			addChild(textCanvas);
			_manager = new TextContainerManager(textCanvas);
			textManager.editingMode = EditingMode.READ_ONLY;
			
			var temColor:Object = textVO.color;
			textVO.color = 0x000000;//文本字体按钮永远都用显示为黑色
			FlowTextManager.renderTextVOLabel(this, textVO);
			textVO.color = temColor;
			
			FlowTextManager.updateTexLayout(textVO.text, textManager);
			textCanvas.scaleX = textCanvas.scaleY = labelHeight / textCanvas.height;
			
			//防止浅色字体与按钮背景相似，看着不明显
			textCanvas.filters = [new DropShadowFilter(1,90, 0xffffff, 1, 1, 1, 3, 3)];
			
			render();
		}
		
		/**
		 */		
		public function render():void
		{
			this.graphics.clear();
			currState.width = textCanvas.width + 20;
			currState.height = textCanvas.height + 10;
			StyleManager.drawRect(this, currState);
		}
		
		/**
		 */		
		private var labelHeight:uint = 12;
		
		/**
		 */		
		public function get id():String
		{
			return textVO.styleID;
		}
			
		
		
		
		
		//---------------------------------------------
		//
		//
		// 文本控制
		//
		//
		//-----------------------------------------------
		
		
		/**
		 */		
		public function get textLayoutFormat():TextLayoutFormat
		{
			return _format;
		}
		
		/**
		 */		
		private var _format:TextLayoutFormat = new TextLayoutFormat;
			
		/**
		 */		
		public function get textManager():TextContainerManager
		{
			return _manager;
		}
		
		/**
		 */		
		private var _manager:TextContainerManager
			
		/**
		 */
		public function get ifMutiLine():Boolean
		{
			return false;
		}
			
		/**
		 */
		public function set ifMutiLine(value:Boolean):void
		{
			
		}
				
		/**
		 */		
		public function get fixWidth():Number
		{
			return _fixWidth;
		}
					
		/**
		 */
		public function set fixWidth(value:Number):void
		{
			_fixWidth = value;
		}
		
		/**
		 */		
		private var _fixWidth:Number = 0;
						
		/**
		 * 字体加载完成后重绘, 然后同时field
		 * 
		 * field 需要进行布局调整
		 */		
		public function afterReRender():void
		{
		}
		
		/**
		 */
		public var textVO:TextVO = new TextVO;
		
		
		
		
		
		
		//-------------------------------------
		//
		//
		//  背景控制
		//
		//
		//-------------------------------------
		
		/**
		 */		
		internal var statesControl:StatesControl;
		
		/**
		 */		
		public function get states():States
		{
			return _states;
		}
		
		/**
		 */		
		public function set states(value:States):void
		{
			_states = value;
		}
		
		/**
		 */		
		private var _states:States = new States;
		
		/**
		 */		
		public function get currState():Style
		{
			return _style;
		}
		
		/**
		 */		
		public function set currState(value:Style):void
		{
			_style = value;
		}
		
		/**
		 */		
		private var _style:Style;
		
		/**
		 */		
		public function hoverHandler():void
		{
		}
		
		/**
		 */		
		public function normalHandler():void
		{
		}
		
		/**
		 */		
		public function downHandler():void
		{
		}
		
		/**
		 */		
		private var bgStyleXML:XML = <states>
										<normal radius='0'>
											<border color='#dddddd'/>
											<fill color='#fdfdfd, #efefef' alpha='1, 1' angle='90'/>
										</normal>
										<hover>
											<border color='#aaaaaa'/>
											<fill color='#f5f5f5, #e8e8e8' alpha='1, 1' angle='90'/>
										</hover>
										<down>
											<border color='#aaaaaa'/>
											<fill color='#ebebeb, #dedede' alpha='1, 1' angle='90'/>
										</down>
									</states>
		
		/**
		 */		
		private var textCanvas:Sprite = new Sprite;
	}
}