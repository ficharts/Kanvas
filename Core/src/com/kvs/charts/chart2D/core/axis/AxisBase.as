package com.kvs.charts.chart2D.core.axis
{
	import com.kvs.charts.chart2D.core.events.FiChartsEvent;
	import com.kvs.charts.chart2D.core.model.SeriesDataFeature;
	import com.kvs.charts.chart2D.core.model.Zoom;
	import com.kvs.charts.chart2D.core.zoomBar.ZoomBar;
	import com.kvs.charts.common.ChartDataFormatter;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.utils.XMLConfigKit.style.elements.BorderLine;
	import com.kvs.utils.graphic.BitmapUtil;
	import com.kvs.utils.graphic.TextBitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	/**
	 * 坐标轴的基类，主要负责绘制坐标轴，具体计算都由不同类型的轴负�
	 * 
	 * 坐标轴有刻度分布密度和数据节点分部密度两方面�
	 * 
	 * 刻度密度由数值步长和最小单元刻度决定， 数据节点分部密度由当前可视区域内包含数据节点密度决定
	 * 
	 */	
	public class AxisBase extends Sprite 
	{
		// Type.
		public static const LINER_AXIS : String = 'linear';
		public static const FIELD_AXIS : String = 'field';
		public static const DATE_AXIS : String = 'date';
		
		// Direction.
		public static const HORIZONTAL_AXIS : String = 'horizontalAxis';
		public static const VERTICAL_AXIX : String = 'verticalAixs';
		
		/**
		 *  Constructor.
		 */		
		public function AxisBase()
		{
			labelUIsCanvas.mouseChildren = false; //labelUIsCanvas.mouseEnabled = false;
			this.addChild(labelUIsCanvas);
			addChild(labelsMask);
			labelUIsCanvas.mask = labelsMask;
			labelUIsCanvas.addEventListener(MouseEvent.CLICK, labelsClickHandler, false, 0, true);
			
			// 初始化当前模�
			curPattern = this.getNormalPatter();
		}
		
		/**
		 * 用户点击坐标轴标签时，触发此事件
		 */		
		private function labelsClickHandler(evt:Event):void
		{
			var clickLoc:Number;
			
			if(this.direction == HORIZONTAL_AXIS)
				clickLoc = labelUIsCanvas.mouseX;
			else
				clickLoc = - labelUIsCanvas.mouseY;
				
			var index:uint = Math.ceil(clickLoc / this.unitSize) - 1;
			
			var labelEvt:FiChartsEvent = new FiChartsEvent(FiChartsEvent.AXIS_LABEL_CLICKED);
			labelEvt.labelIndex = index;
			labelEvt.label = this.labelVOes[index].label;
			this.dispatchEvent(labelEvt);
		}
		
		/**
		 */		
		private var _ifCeilEdgeValue:Boolean = true;

		/**
		 * 自动将线性坐标轴边缘取整�在大数据滚动图表中用�
		 * 
		 * 
		 * 
		 */
		public function get ifCeilEdgeValue():Boolean
		{
			return _ifCeilEdgeValue;
		}

		/**
		 * @private
		 */
		public function set ifCeilEdgeValue(value:Boolean):void
		{
			_ifCeilEdgeValue = value;
		}

		
		/**
		 *  是否隐藏边缘label，因 第一个和最后一个label经常会跨越坐标轴边缘
		 * 
		 *  设置此属性可以将边缘label隐藏掉；
		 * 
		 *  主要用于数据滚动轴图表的x边缘label隐藏
		 */		
		private var _ifHideEdgeLabel:Boolean = false

		/**
		 */			
		public function get ifHideEdgeLabel():Boolean
		{
			return _ifHideEdgeLabel;
		}

		/**
		 */		
		public function set ifHideEdgeLabel(value:Boolean):void
		{
			_ifHideEdgeLabel = XMLVOMapper.boolean(value);
		}
		
		/**
		 * 用于给滚动轴复制坐标�
		 * 
		 * 这时原始数据刚刚配置完毕,dataUptated之前
		 */		
		public function clone():AxisBase
		{
			return null;
		}
		
		/**
		 */		
		protected function initClone(axis:AxisBase):void
		{
			axis.sourceValues = this.sourceValues.concat();
			axis.dataFormatter = this.dataFormatter;
			axis.mdata = this.mdata;
		}
		
		/**
		 */		
		public function hideDataRender():void
		{
			curPattern.hideDataRender();
		}
		
		/**
		 */		
		public function updateTipsData():void
		{
			this.curPattern.updateTipsData();
		}
		
		
		/**
		 * 原始数据不一定等于坐标轴上的数据节点�例如时间类型的坐标轴
		 * 
		 * 校验后的值是数字(time)，原始值是字符�2001-12-01)
		 */		
		public function getVerifyData(data:Object):Object
		{
			return data;
		}
		
		/**
		 */		
		public function adjustZoomFactor(scaleModel:Zoom):void
		{
			curPattern.adjustZoomFactor(scaleModel);
		}
		
		/**
		 */		
		public function toNomalPattern():void
		{
			if(curPattern)
				curPattern.toNormalPattern();
			else
				curPattern = getNormalPatter();
			
			zoomBar.distory();
			this.removeChild(zoomBar)
			zoomBar = null;
		}
		
		/**
		 */		
		public function toZoomPattern():void
		{
			if (curPattern)
				curPattern.toZoomPattern();
			else
				curPattern = getZoomPattern();
			
			this.curPattern.dataUpdated();
			
			if (zoomBar == null)
			{
				zoomBar = new ZoomBar(this);
				this.addChild(zoomBar);
			}
		}
		
		/**
		 */		
		internal function getNormalPatter():IAxisPattern
		{
			return null;
		}
		
		/**
		 */		
		internal function getZoomPattern():IAxisPattern
		{
			return null;
		}
		
		/**
		 */		
		internal var curPattern:IAxisPattern;
		
		/**
		 */		
		internal var normalPattern:IAxisPattern;
		
		/**
		 */		
		internal var zoomPattern:IAxisPattern;
		
		/**
		 * 根据原始数据得到其在总数据中的百分比位置，用来做尺寸缩放
		 */		
		public function getDataPercent(value:Object):Number
		{
			return curPattern.getPercentByData(value);
		}
		
		/**
		 * 将原始的值转换为百分比，用于初次根据配置文件获取缩放比率�
		 * 
		 * 因为坐标轴很早就已渲染，进行了数据筛�
		 */		
		public function getSourceDataPercent(value:Object):Number
		{
			return curPattern.getPercentBySourceData(value);
		}
		
		/**
		 */		
		public function posToPercent(pos:Number):Number
		{
			return curPattern.posToPercent(pos);
		}
		
		/**
		 * 将百分比位置信息转换为真正的位置数�
		 */		
		public function percentToPos(per:Number):Number
		{
			return curPattern.percentToPos(per);
		}
		
		/**
		 * 滚动结束后，渲染数据范围内的序列
		 */		
		public function dataScrolled(dataRange:DataRange):void
		{
			curPattern.dataScrolled(dataRange);
		}
		
		/**
		 * 数据缩放后调�
		 */		
		public function dataResized(dataRange:DataRange):void
		{
			changed = true;
			curPattern.dataResized(dataRange);
		}
		
		/**
		 * 数据滚动过程中，仅需要绘制显示范围内的Label
		 * */
		public function scrollingByChartCanvas(offset:Number):void
		{
			curPattern.scrollingByChartCanvas(offset);
		}
		 
		 /** 
		 * 对于每此数据缩放，坐标轴仅需绘制一次，子数据的滚动只是移动label容器的位置而已
		 */		
		public function renderHoriticalAxis():void
		{
			if (changed && this.labelVOes.length)
			{
				this.labelsMask.graphics.clear();
				
				
				this.curPattern.renderHorLabelUIs();
				
				// 横轴的坐标轴遮罩只绘制一次，图表初始化时会先整个坐标轴一起渲�
				this.labelsMask.graphics.beginFill(0);
				if (this.position == 'bottom')
				{
					this.labelsMask.graphics.drawRect(- temUintSize / 2, 0, 
						this.size + this.temUintSize, this.labelUIsCanvas.height);
				}
				else
				{
					this.labelsMask.graphics.drawRect(- temUintSize / 2, - this.labelUIsCanvas.height, 
						this.size + this.temUintSize, this.labelUIsCanvas.height);
				}
				labelsMask.graphics.endFill();
				
				if (enable)
					createHoriticalTitle();
				
				adjustHoriTicks();
				
				if (enable && this.tickMark.enable)
					drawHoriTicks();
				
				changed = false;
			}
		}
		
		/**
		 * 将显示区域内的label绘制，如果label未被创建，那么先创建其在绘制
		 */		
		internal function renderHoriLabelUIs(startIndex:int, endIndex:int, length:int):void
		{
			var labelUI:LabelUI;
			var labelVO:AxisLabelData;
			var valuePositon:Number;
			
			// 横向的最小间距不能小于Label的宽度， 这里要先获取这个宽度，从而决定单元间隔数
			var i:uint;
			
			// 先获得字符数最长的label位置�然后根据其获取最小单元宽�
			var labelLen:uint = 0;
			var labelIndex:uint = 0;
			var temLabelLen:uint = 0;
			for (i = startIndex; i <= endIndex; i ++)
			{
				temLabelLen = this.getXLabel(labelVOes[i].value).length;
				if (temLabelLen > labelLen)
				{
					labelLen = temLabelLen;
					labelIndex = i;
				}
			}
			
			labelUI = createLabelUI(labelIndex);
			temUintSize = minUintSize;//轴的尺寸刷新�minUintSize 会重新计算，避免之前的大尺寸和谐掉后继的小尺�
			
			// 自动调整label布局模式
			if(isAutoLabelLayout)
			{
				if (labelUI.width > this.unitSize)
					label.layout = autoLabelLayout;
				else
					label.layout = LabelStyle.NORMAL;
			}
			
			
			// 线性轴的label UI 每次渲染创建时都需要重新计� minUintSize ，因为每次的Label都是重新生成�
			if (label.layout == LabelStyle.VERTICAL)
			{
				if (labelUI.height > temUintSize)
					temUintSize = labelUI.height;
			}
			else if (label.layout == LabelStyle.ROTATION)
			{
				if (labelUI.width * 0.5 > temUintSize)
					temUintSize = labelUI.width * 0.5;
			}
			else
			{
				if (labelUI.width > temUintSize)
					temUintSize = labelUI.width;
			}
			
			//保证标签间距大于最小单元宽度， 防止标签重叠�
			var addFactor:uint = 1;
			var uintAmount:uint = length;
			while (size > 0 && (size / uintAmount) < temUintSize)
			{
				addFactor += 1;
				uintAmount = length / addFactor;
			}
			
			// 布局和显示数据范围内的label
			_ticks.length = 0;
			
			for (i = startIndex; i <= endIndex; i += addFactor)
			{
				valuePositon = this.curPattern.valueToSize(labelVOes[i].value, - 1)
				_ticks.push(valuePositon);
				
				if (enable)
				{
					labelUI = labelUIs[i];
					
					if (labelUI == null)
						labelUI = createLabelUI(i);
					
					drawHoriLabelUI(labelUI, valuePositon);
				}
			}
			
		}
		
		/**
		 * 开启后，横向坐标轴自动计算label的布局方式，label宽度大于单元格宽度则旋转label
		 */
		public function get isAutoLabelLayout():Object
		{
			return _isAutoLabelLayout;
		}
		
		/**
		 * @private
		 */
		public function set isAutoLabelLayout(value:Object):void
		{
			_isAutoLabelLayout = XMLVOMapper.boolean(value);
		}
		
		/**
		 */		
		private var _isAutoLabelLayout:Object = false;
		
		/**
		 */		
		private var _autoLabelLayout:String = "rotation";

		/**
		 */
		public function get autoLabelLayout():String
		{
			return _autoLabelLayout;
		}

		/**
		 * @private
		 */
		public function set autoLabelLayout(value:String):void
		{
			_autoLabelLayout = value;
		}

		/**
		 */		
		private function drawHoriLabelUI(labelUI:LabelUI, valuePositon:Number):void
		{
			var labelX:Number = 0;
			var labelY:Number = 0;
			
			if (label.layout == LabelStyle.ROTATION)
			{
				labelY = Math.sin(Math.PI / 4) * labelUI.width;
				if (this.position == 'bottom')
					labelY = label.margin + labelY;
				else
					labelY = - label.margin - labelUI.height - labelY;
				
				labelUI.x = - Math.cos(Math.PI / 4) * labelUI.width + valuePositon;
				labelUI.y = labelY;
				labelUI.rotation = - 45
				labelUIsCanvas.addChild(labelUI);
			}
			else if (label.layout == LabelStyle.VERTICAL)
			{
				
				
				labelY = labelUI.width;
				if (this.position == 'bottom')
					labelY = label.margin + labelY;
				else
					labelY = - label.margin - labelUI.height - labelY;
				
				labelUI.x = - labelUI.height / 2 + valuePositon;
				labelUI.y = labelY;
				labelUI.rotation = - 90;
				labelUIsCanvas.addChild(labelUI);
			}
			else
			{
				labelUI.x = - labelUI.width / 2 + valuePositon;
				
				if (this.position == 'bottom')
					labelUI.y = label.margin;
				else
					labelUI.y = - label.margin - labelUI.height;
				
				labelUIsCanvas.addChild(labelUI);
			}
		}
		
		/**
		 * 
		 */		
		private function createLabelUI(index:uint):LabelUI
		{
			var labelVO:AxisLabelData, ui:LabelUI;
			
			labelVO = labelVOes[index];
			labelVO.label = getXLabel(labelVO.value);
			labelVO.color = mdata.color;
			
			labelRender = new LabelUI;
			labelRender.style = this.label;
			labelRender.mdata = labelVO;
			
			// 如果label换行显示，那么先以单元宽度为�
			if (labelDisplay == LabelStyle.WRAP)
				labelRender.maxLabelWidth = unitSize;
			
			labelRender.render();
			
			// 这里的labelUI可考虑用bitmap data绘制来优化渲�
			ui = labelUIs[index] = labelRender;
			
			return ui;
		}
		
		/**
		 * 仅字段型坐标轴才需要调节刻度线位置
		 */		
		internal function adjustHoriTicks():void
		{
			
		}
		
		/**
		 * 纵轴暂时不存在数据缩放控制，渲染单纯很多
		 */		
		public function renderVerticalAxis():void
		{
			if (changed && this.labelVOes.length)
			{
				this.clearLabels();
				this.labelsMask.graphics.clear();
				
				var labelUI:LabelUI;
				var length:uint = this.labelVOes.length;
				var valuePositon:Number;
				
				var labelX:Number;
				var labelY:Number;
				
				var i:uint;
				var labelVO:AxisLabelData;
				temUintSize = minUintSize;
				
				for (i = 0; i < length; i ++)
				{
					if (this.enable)
					{
						labelUI = labelUIs[i];
						
						if (labelUI == null)
						{
							labelVO = labelVOes[i];
							labelVO.label = this.getYLabel(labelVO.value);
							labelVO.color = this.mdata.color;
							
							labelRender = new LabelUI;
							labelRender.style = this.label;
							labelRender.mdata = labelVO;
							labelRender.render();
							
							labelUI = labelUIs[i] = labelRender;
							restoreLabel(labelVO, labelUI);// 创建一对，存储一对儿
						}
						
						if (label.layout == LabelStyle.ROTATION)
						{
							if (labelUI.width > temUintSize)
								temUintSize = labelUI.width;
						}
						else
						{
							if (labelUI.height > temUintSize)
								temUintSize = labelUI.height;
						}
						
					}
					
				}
				
				//保证标签间距大于最小单元宽度， 防止标签重叠�
				var addFactor:uint = 1;
				var uintAmount:uint = length;
				while (size > 0 && (this.size / uintAmount) < temUintSize)
				{
					addFactor += 1;
					uintAmount = length / addFactor;
				}
				
				_ticks.length = 0;
				for (i = 0; i < length; i += addFactor)
				{
					valuePositon = valueToY(labelVOes[i].value);
					_ticks.push(valuePositon);
					
					if (enable)
					{
						labelUI = labelUIs[i];
						
						if (position == "left")
							labelUI.x = - labelUI.width - label.margin;
						else
							labelUI.x = label.margin;
							
						labelUI.y =  valuePositon -  labelUI.height / 2;
						
						labelUIsCanvas.addChild(labelUI);
					}
				}
				
				this.labelsMask.graphics.beginFill(0);
				if (position == "left")
				{
					this.labelsMask.graphics.drawRect(0, temUintSize / 2, 
						- this.labelUIsCanvas.width - 2, - this.size - this.temUintSize);
				}
				else
				{
					this.labelsMask.graphics.drawRect(0, temUintSize / 2, 
						 this.labelUIsCanvas.width + 2, - this.size - this.temUintSize);
				}
				
				labelsMask.graphics.endFill();
				
				if (enable)
					createVerticalTitle();
				
				adjustVertiTicks();
				
				if (enable && tickMark.enable)
					drawVertiTicks();
				
				changed = false;
			}
		}
		
		/**
		 * 数据缩放中，y轴会动态刷新，存储下label数据避免了重复构建渲染其性能开销
		 * 
		 * 这个开销挺大�
		 */		
		protected function restoreLabel(vo:AxisLabelData, ui:LabelUI):void
		{
			
		}
		
		/**
		 */		
		protected function adjustVertiTicks():void
		{
		}
		
		/**
		 */		
		internal function drawHoriTicks():void
		{
			// 绘制刻度�
			StyleManager.setLineStyle(this.labelUIsCanvas.graphics, tickMark);
			
			for (var i:uint = 1; i < ticks.length - 1; i ++)
			{
				labelUIsCanvas.graphics.moveTo(ticks[i], 0);
				
				if (position == 'bottom')
					labelUIsCanvas.graphics.lineTo(ticks[i], tickMark.size);
				else
					labelUIsCanvas.graphics.lineTo(ticks[i], - tickMark.size);
			}
		}
		
		/**
		 */		
		protected function drawVertiTicks():void
		{
			// 绘制刻度�
			StyleManager.setLineStyle(labelUIsCanvas.graphics, tickMark);
			
			for (var i:uint = 1; i < ticks.length - 1; i ++)
			{
				labelUIsCanvas.graphics.moveTo(0, ticks[i]);
				if (position == "left")
					labelUIsCanvas.graphics.lineTo(- tickMark.size, ticks[i]);
				else
					labelUIsCanvas.graphics.lineTo(tickMark.size, ticks[i]);
			}
		}
		
		/**
		 */		
		protected function createHoriticalTitle():void
		{
			if(titleLabelH && titleLabelH.parent)
				this.removeChild(titleLabelH);
			
			if (title && title.text.value)
			{
				if (titleLabelH == null)
					titleLabelH = new LabelUI;
				
				titleLabelH.style = title;
				titleLabelH.mdata = this.mdata;
				titleLabelH.render();
				
				titleLabelH.x = size * .5 - titleLabelH.width * .5;
				
				if (position == 'bottom')
				{
					if (this.zoomBar)
						titleLabelH.y = this.labelUIsCanvas.height + title.margin + zoomBar.barHeight;
					else
						titleLabelH.y = this.labelUIsCanvas.height + title.margin;
				}
				else
				{
					titleLabelH.y = - labelUIsCanvas.height - title.margin - titleLabelH.height;
				}
				
				this.addChild(titleLabelH);
			}
		}
		
		/**
		 */		
		protected function createVerticalTitle():void
		{
			if(titleLabelH && titleLabelV && titleLabelV.parent)
				this.removeChild(titleLabelV);
			
			if (title && title.text.value)
			{
				if (titleLabelV == null)
					titleLabelV = new LabelUI;
				
				titleLabelV.mdata = this.mdata;
				titleLabelV.style = title;
				titleLabelV.render();
				
				titleLabelV.rotation =  - 90;
				
				if(this.position == "left")
					titleLabelV.x = - this.labelUIsCanvas.width - title.margin - titleLabelV.width;
				else
					titleLabelV.x = labelUIsCanvas.width + title.margin;
				
				titleLabelV.y = - size * .5 + titleLabelV.height * .5;
				addChild(titleLabelV);
			}
		}
		
		/**
		 *  Clear labels.
		 */		
		internal function clearLabels() : void
		{
			this.labelUIsCanvas.graphics.clear();
			
			while (labelUIsCanvas.numChildren)
				labelUIsCanvas.removeChildAt(0);
		}
		
		
		/**
		 * 获取序列的数值范围，最值；
		 */		
		public function getSeriesDataFeature(seriesData:Vector.<Object>):SeriesDataFeature
		{
			var seriesDataFeature:SeriesDataFeature = new SeriesDataFeature;
			
			return seriesDataFeature;
		}
		
		/**
		 */		
		internal var labelRender:LabelUI;
		
		/**
		 */		
		private var labelsMask:Shape = new Shape;
		internal var labelUIs:Array = [];
		
		/**
		 * label的容器用来数据缩放时整体移动label，辅助遮罩效�
		 */		
		public var labelUIsCanvas:Sprite = new Sprite;
		
		/**
		 * 
		 */		
		private var titleLabelH:LabelUI;
		
		/**
		 */		
		private var titleLabelV:LabelUI;
		
		/**
		 * 轴标签数�
		 */
		internal var labelVOes:Vector.<AxisLabelData> = new Vector.<AxisLabelData>;
		
		
		
		//---------------------------------------------------
		//
		// 
		//  数据初始化， 数据缩放中Y轴需动态更新，也许处理数据
		//
		//
		//--------------------------------------------------
		
		/**
		 */		
		public function redayToUpdataYData():void
		{
		}
		
		/**
		 */		
		public function pushYData(value:Vector.<Object>):void
		{
		}
		
		/**
		 */		
		public function yDataUpdated():void
		{
		}
		
		
		/**
		 *     
		 *  以下是原始数据的处理
		 * 
		 */		
		
		
		/**
		 */		
		public function redyToUpdateData():void
		{
			sourceValues.length = 0;
		}
		
		/**
		 */		
		public function pushValues(values:Vector.<Object>) : void
		{
			
		}
		
		/**
		 */		
		public function dataUpdated():void
		{
			if(label)
			{
				this.label.layout = this.labelDisplay;
				
				if (label.layout == LabelStyle.NONE)
					label.enable = false;
				else 
					label.enable = true;
			}
			
			changed = true;
		}
		
		/**
		 * 尺寸更新后更新坐标轴相关属性；
		 * 
		 * 计算最大最小值，间隔刻度，label数据
		 */
		public function beforeRender():void
		{
			if (this.changed)
				this.curPattern.beforeRender();
		}
		
		/**
		 * 原始数据
		 */		
		public var sourceValues:Array = [];
		
		/**
		 * 轴的创建�尺寸�数据改变此标识都会为真；
		 */		
		internal var changed:Boolean = true;
		
		/**
		 */		
		internal var _ticks:Vector.<Number> = new Vector.<Number>;
		
		/**
		 */
		public function get ticks():Vector.<Number>
		{
			return _ticks;
		}
		
		
		/**
		 * @return 
		 * 
		 */		
		protected function get type() : String
		{
			return null;
		}
		
		/**
		 */		
		private var _direction : String;
		public function set direction( value : String ) : void
		{
			_direction = value;
		}
		
		public function get direction() : String
		{
			return _direction;
		}
		
		/**
		 * The size of this axis. 
		 */		
		protected var _length : Number;
		public function set size( value : Number ) : void
		{
			_length = value;
			changed = true;
		}
		
		public function get size() : Number
		{
			return _length;
		}
		
		/**
		 *  标准单元格尺寸，为显示尺寸内，显示的数据范围除以单元数据而来
		 * 
		 *  因为label可能会很长，label间距为单元刻度的倍数
		 */
		private var _uintSize:Number = 0;
		
		public function get unitSize():Number
		{
			return _uintSize;
		}
		
		public function set unitSize(value:Number):void
		{
			_uintSize = value;
		}
		
		/**
		 * 这个值有可能比uinitSize要大，取决于label的尺�
		 */
		public var temUintSize:Number = 0;
		
		/**
		 */		
		public var minUintSize:uint = 10;
		/**
		 * @param value
		 */		
		public function valueToY( value : Object ) : Number
		{
			return 0;
		}
		
		/**
		 */		
		public function valueToZ(value:Object):Number
		{
			return 0;
		}
		
		/**
		 * 
		 * 大数据量计算时， 根据数据再获取其位置信息很耗性能�所以把位置直接
		 * 
		 * 传进来，方便 Field 轴的位置计算
		 * 
		 * @param value
		 * @return 
		 */		
		public function valueToX(value:Object, index:int):Number
		{
			return 0;
		}
		
		/**
		 */		
		protected function valueToSize(value:Object, index:int):Number
		{
			return this.curPattern.valueToSize(value, index);
		}
		
		/**
		 */		
		protected var _disPlayName:String
		public function set displayName(value:String) : void
		{
			_disPlayName = value;
		}
		
		/**
		 * 如果没有设置 displayName 则继承自 title;
		 */		
		public function get displayName():String
		{
			if (_disPlayName)
				return _disPlayName
			else	
				return this.title.text.value;
		}
		
		/**
		 */		
		private var _paddingLeft:Number = 0;
		
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void
		{
			_paddingLeft = value;
		}
		
		private var _paddingRight:Number = 0;
		
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void
		{
			_paddingRight = value;
		}

		
		
		
		
		//---------------------------------------
		//
		// 数据格式�
		//
		//---------------------------------------
		
		public function getXLabel(value:Object):String
		{
			return null;
		}
		
		public function getYLabel(value:Object):String
		{
			return null;
		}
		
		public function getZLabel(value:Object):String
		{
			return null;
		}
		
		
		private var _dataFormatter:ChartDataFormatter;
		
		/**
		 */
		public function get dataFormatter():ChartDataFormatter
		{
			return _dataFormatter;
		}
		
		/**
		 * @private
		 */
		public function set dataFormatter(value:ChartDataFormatter):void
		{
			// 默认采用全局配置�也可单独配置�
			if (this._dataFormatter == null)
				_dataFormatter = value;
		}
		
		
		
		
		//------------------------------------------------
		//
		// 坐标轴公共属�
		//
		//------------------------------------------------
		
		/**
		 * 是否显示/渲染坐标轴； 
		 */		
		private var _enable:Object = true;

		public function get enable():Object
		{
			return _enable;
		}

		public function set enable(value:Object):void
		{
			_enable = XMLVOMapper.boolean(value);
		}

		/**
		 */		
		private var _id:String = "";
		
		/**
		 * @return 
		 */		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		/**
		 *  决定坐标轴的布局位置�top, bottom, left, right;
		 */		
		private var _postition:String;

		/**
		 */
		public function get position():String
		{
			return _postition;
		}

		/**
		 * @private
		 */
		public function set position(value:String):void
		{
			_postition = value;
		}
		
		/**
		 * 是否翻转坐标轴的计算方式，此属性配合position可以决定 
		 */		
		private var _inverse:Object = false;
		
		/**
		 */
		public function get inverse():Object
		{
			return _inverse;
		}
		
		/**
		 * @private
		 */
		public function set inverse(value:Object):void
		{
			_inverse = XMLVOMapper.boolean(value);
		}

		/**
		 * 坐标轴标�
		 */		
		private var _title:LabelStyle;

		public function get title():LabelStyle
		{
			return _title;
		}

		public function set title(value:LabelStyle):void
		{
			_title = value;
		}
		
		/**
		 */		
		public function get labelDisplay():String
		{
			return _labelDisplay;
		}

		public function set labelDisplay(value:String):void
		{
			_labelDisplay = value;
		}
		
		/**
		 */		
		private var _labelDisplay:String = LabelStyle.NORMAL;

		/**
		 * 数值标�
		 */		
		private var _label:LabelStyle
		
		/**
		 */
		public function get label():LabelStyle
		{
			return _label;
		}

		/**
		 * @private
		 */
		public function set label(value:LabelStyle):void
		{
			_label = value;
		}
		
		/**
		 * 坐标刻度 
		 */		
		private var _tickMark:TickMarkStyle;

		/**
		 */
		public function get tickMark():TickMarkStyle
		{
			return _tickMark;
		}

		/**
		 * @private
		 */
		public function set tickMark(value:TickMarkStyle):void
		{
			_tickMark = value;
		}
		
		/**
		 */		
		private var _line:BorderLine;

		/**
		 * 坐标轴线样式
		 */
		public function get line():BorderLine
		{
			return _line;
		}

		/**
		 * @private
		 */
		public function set line(value:BorderLine):void
		{
			_line = value;
		}
		
		/**
		 */		
		private var _metaData:Object;

		/**
		 */
		public function get mdata():Object
		{
			return _metaData;
		}

		/**
		 * @private
		 */
		public function set mdata(value:Object):void
		{
			_metaData = value;
		}
		
		
		
		
		
		//--------------------------------------------------------------
		//
		//  
		// 数据滚动条的控制
		//
		//
		//---------------------------------------------------------------
		
		
		/**
		 */		
		internal function updateScrollBarSize(startPerc:Number, endPerc:Number):void
		{
			zoomBar.updateWindowSize(startPerc, endPerc);
		}
		
		/**
		 */		
		internal function updateScrollBarPos(perc:Number):void
		{
			zoomBar.updateWindowPos(perc);
		}
		
		/**
		 */		
		internal function upateDataStep(value:uint):void
		{
			zoomBar.updateChartDataStep(value);
		}
		
		/**
		 */		
		public var zoomBar:ZoomBar;

	}
}