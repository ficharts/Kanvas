package com.kvs.charts.chart2D.core.axis
{
	import com.kvs.charts.chart2D.core.model.SeriesDataFeature;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.utils.format.DateFormater;
	
	/**
	 */
	public class DateAxis extends LinearAxis
	{
		/**
		 * Constructor.
		 */
		public function DateAxis()
		{
			super();
			
			millisecondsP = "milliseconds";
			secondsP = "seconds";
			minutesP = "minutes";
			hoursP = "hours";
			dateP = "date";
			dayP = "day";
			monthP = "month";
			fullYearP = "fullYear";         
		}
		
		/**
		 */		
		override public function clone():AxisBase
		{
			var axis:AxisBase = new DateAxis;
			initClone(axis);
			
			return axis;
		}
		
		/**
		 * 
		 * 数据滚动过程中，label数据不变，仅动态更新显�
		 * 
		 */		
		override internal function createLabelsData(max:Number, min:Number):void
		{
			var labelValue:String;
			labelVOes.length = labelUIs.length = labelValues.length = 0;
			var startDate:Date = new Date();
			var currenDate:Date = new Date;
			var labelData:AxisLabelData;
			var i:uint;
			startDate.setTime(min);
			
			for (i = 0; i < uintAmount; i ++)
			{
				labelData = new AxisLabelData;
				currenDate.setTime(min);
				
				switch (lastValidUnits)
				{
					case "seconds":
					{
						currenDate.setSeconds(startDate.getSeconds() + i)
						break;
					}
					case "hours":
					{
						currenDate.setHours(startDate.getHours()+ i)
						break;
					}
					case "days":
					{
						currenDate.setDate(startDate.getDate()+ i)
						break;
					}
					case "minutes":
					{
						currenDate.setMinutes(startDate.getMinutes()+ i)
						break;
					}
					case "years":   
					{
						currenDate.setFullYear(startDate.getFullYear()+ i)
						break;
					}
					case 'months':
					{
						currenDate.setMonth(startDate.getMonth()+ i)
						break;
					}
				}
				
				labelData.value = currenDate.time;
				labelVOes[i] = labelData;
				labelValues[i] = labelData.value;
			}
			
		}
			
		override internal function getNormalPatter():IAxisPattern
		{
			return new DateAxis_Normal(this);
		}
		
		/**
		 */		
		override internal function getZoomPattern():IAxisPattern
		{
			return new DateAxis_DataScale(this);
		}
		
		private var _input:String = 'YYYY/MM/DD';

		/**
		 * 输入格式
		 */
		public function get input():String
		{
			return _input;
		}

		/**
		 * @private
		 */
		public function set input(value:String):void
		{
			_input = value;
		}
		
		/**
		 * 输出格式
		 */
		public function get output():String
		{
			return (this.curPattern as IDateAxisPattern).output;
		}

		/**
		 * @private
		 */
		public function set output(value:String):void
		{
			(this.curPattern as IDateAxisPattern).output = value;
		}

		/**
		 */		
		override public function getSeriesDataFeature(seriesData:Vector.<Object>):SeriesDataFeature
		{
			var seriesDataFeature:SeriesDataFeature = new SeriesDataFeature;
				
			
			DateFormater
			
			//TODO
			return seriesDataFeature;
		}
		
		/**
		 */		
		override public function dataUpdated():void
		{
			sourceValues.sort(Array.NUMERIC);
			
			if (!isNaN(assignedMinimum))
				sourceMin = assignedMinimum;
			else
				sourceMin = Number(sourceValues[0]);
			
			if (!isNaN(assignedMaximum))
				sourceMax = assignedMaximum;
			else
				sourceMax = Number(sourceValues[sourceValues.length - 1]);
			
			// 单值的情况�
			if (sourceValues.length == 1)
				sourceMin = sourceMax = Number(sourceValues[0]);
			
			if (autoAdjust == false)
			{
				_maximum = sourceMax;
				_minimum = sourceMin;
				
				this.changed = false;
				
				// 气泡图的控制气泡大小的轴无需渲染，原始刻度间距即为确认的间距
				sourceValueDis = _maximum - _minimum;
				return; 
			}
			
			sourceValueDis = sourceMax - sourceMin;
			
			if (label)
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
		 */		
		override internal function preMaxMin(max:Number, min:Number):void
		{
			miniUnitCount = Math.floor(this.size / maxUnitSize);
			
			//最小单位�
			var minD:Date = new Date(max);
			var maxD:Date = new Date(min);
			var minMilli:Number = preMax;
			var maxMilli:Number = preMin;
			var units:String = "years";
			var valueDis:Number;
			var miniInternal:Number;
			var lastValidMin:Number;
			var lastValidMax:Number;
			lastValidUnits = units;
			
			while (units != null)
			{
				preInterval = toMilli(1, units);
				
				minD.setTime(min);
				roundDateDown(minD, units);
				minMilli = minD.getTime();
				
				maxD.setTime(max);
				roundDateUp(maxD, units);
				maxMilli = maxD.getTime();
				
				valueDis = maxMilli - minMilli;// 临时差值；
				miniInternal = toMilli(1, getMiniInternalUint(valueDis));
				
				if (preInterval >= miniInternal)
				{
					lastValidMin = minMilli;
					lastValidMax = maxMilli;
					lastValidUnits = units;
				}
				else
				{
					break;
				}
				
				units = UNIT_PROGRESSION[units];
			}
			
			_minimum  = lastValidMin;
			_maximum = lastValidMax;
			
			interval = toMilli(1, lastValidUnits);
		}
		
		/**
		 * 核定，确定最大最小�
		 */		
		override internal function confirmMaxMin(axisLen:Number):void
		{
			confirmedDis = _maximum - _minimum;
			uintAmount = Math.ceil(this.sourceValueDis / interval) + 1;
		}
		
		/**
		 * 单元刻度的总数
		 */		
		internal var uintAmount:uint;
		
		/**
		 */		
		private var miniUnitCount:uint = 0;
		
		/**
		 * 最大单元刻度， 单元刻度大于其时，时间间隔进入下一层级，避免时间间隔过�
		 */		
		private var maxUnitSize:uint = 180;
		
		/**
		 * 当前时间跨度下最小的刻度间隔
		 */		
		internal var lastValidUnits:String;
		
		/**
		 */		
		override public function getXLabel(value:Object):String
		{
			return dataFormatter.formatXString(dateTimeToString(value));
		}
		
		/**
		 */		
		override public function getYLabel(value:Object):String
		{
			return dataFormatter.formatYString(dateTimeToString(value));
		}
		
		/**
		 * 将Time类型的时间转换为合理的时间显示格式；
		 */		
		internal function dateTimeToString(value:Object):String
		{
			return (this.curPattern as IDateAxisPattern).dateTimeToString(value);
		}
		
		/**
		 */		
		override public function getVerifyData(data:Object):Object
		{
			return stringDateToDateTimer(data);
		}
		
		/**
		 * 将字符串转换为毫秒类型的时间�
		 */
		internal function stringDateToDateTimer(value:Object):Number
		{
			return DateFormater.stringToDate(value.toString(), this.input).time;
			return dateForTransform.getTime();
		}
		
		/**
		 * 用来辅助时间数值的转换，避免重复构建Date对象消耗性能 
		 */		
		internal var dateForTransform:Date = new Date;
		
		/**
		 */		
		private function roundDateUp(d:Date,units:String):void
		{
			switch (units)
			{
				case "seconds":
					if (d[millisecondsP] > 0)
					{
						d[secondsP] = d[secondsP] + 1;
						d[millisecondsP] = 0;
					}
					break;
				case "minutes":
					if (d[secondsP] > 0 || d[millisecondsP] > 0)
					{
						d[minutesP] = d[minutesP] + 1;
						d[secondsP] = 0;
						d[millisecondsP] = 0;
					}
					break;
				case "hours":
					if (d[minutesP] > 0 ||
						d[secondsP] > 0 ||
						d[millisecondsP] > 0)
					{
						d[hoursP] = d[hoursP] + 1;
						d[minutesP] = 0;
						d[secondsP] = 0;
						d[millisecondsP] = 0;
					}
					break;
				case "days":
					if (d[hoursP] > 0 ||
						d[minutesP] > 0 ||
						d[secondsP] > 0 ||
						d[millisecondsP] > 0)
					{
						d[hoursP] = 0;
						d[minutesP] = 0;
						d[secondsP] = 0;
						d[millisecondsP] = 0;
						d[dateP] = d[dateP] + 1;                                        
					}
					break;
				d[hoursP] = 0;
				d[minutesP] = 0;
				d[secondsP] = 0;
				d[millisecondsP] = 0;
				break;          
				case "weeks":
					d[hoursP] = 0;
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					if (d[dayP] != 0)
						d[dateP] = d[dateP] + (7 - d[dayP]);
					break;          
				case "months":
					if (d[dateP] > 1 ||
						d[hoursP] > 0 ||
						d[minutesP] > 0 ||
						d[secondsP] > 0 ||
						d[millisecondsP] > 0)
					{
						d[hoursP] = 0;
						d[minutesP] = 0;
						d[secondsP] = 0;
						d[millisecondsP] = 0;
						d[dateP] = 1;
						d[monthP] = d[monthP] + 1;
					}
					break;
				case "years":
					if (d[monthP] > 0 ||
						d[dateP] > 1 ||
						d[hoursP] > 0 ||
						d[minutesP] > 0 ||
						d[secondsP] > 0 ||
						d[millisecondsP] > 0)
					{
						d[hoursP] = 0;
						d[minutesP] = 0;
						d[secondsP] = 0;
						d[millisecondsP] = 0;
						d[dateP] = 1;
						d[monthP] = 0;
						d[fullYearP] = d[fullYearP] + 1;
					}
					break;
			}                                                                           
		}
		
		/**
		 * 根据当前的时间跨度计算出合理的单元单位；
		 */		
		private function getMiniInternalUint(dis:Number):String
		{
			if (Math.floor(dis / MILLISECONDS_IN_YEAR) >= miniUnitCount)
			{
				return 'years'
			}
			else if (Math.floor(dis / MILLISECONDS_IN_MONTH) >= miniUnitCount)
			{
				return 'months';
			}
			else if (Math.floor(dis / MILLISECONDS_IN_DAY) >= miniUnitCount)
			{
				return 'days'
			}
			else if (Math.floor(dis / MILLISECONDS_IN_HOUR) >= miniUnitCount)
			{
				return 'hours'
			}
			else if (Math.floor(dis / MILLISECONDS_IN_MINUTE) >= miniUnitCount)
			{
				return 'minutes';
			}
			else
			{
				return 'seconds';
			}
		}
		
		/**
		 */		
		private function roundDateDown(d:Date,units:String):void
		{
			switch (units)
			{
				case "seconds":
					d[secondsP] = 0;
					break;
				case "minutes":
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					break;
				case "hours":
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					break;
				case "days":
					d[hoursP] = 0;
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					break;
				case "weeks":
					d[hoursP] = 0;
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					if (d[dayP] != 0)
						d[dateP] = d[dateP] - d[dayP];
					break;
				case "months":
					d[hoursP] = 0;
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					d[dateP] = 1;
					break;
				case "years":
					d[hoursP] = 0;
					d[minutesP] = 0;
					d[secondsP] = 0;
					d[millisecondsP] = 0;
					d[dateP] = 1;
					d[monthP] = 0;
					break;  
			}
		}
		
		/**
		 */		
		private function toMilli(v:Number, unit:String):Number
		{
			switch (unit)
			{
				case "milliseconds":
				{
					return v;
				}
					
				case "seconds":
				{
					return v * 1000;
				}
					
				case "minutes":
				{
					return v * MILLISECONDS_IN_MINUTE;
				}
					
				case "hours":
				{
					return v * MILLISECONDS_IN_HOUR;
				}
					
				case "weeks":
				{
					return v * MILLISECONDS_IN_WEEK;
				}
					
				case "months":
				{
					return v * MILLISECONDS_IN_MONTH;
				}
					
				case "years":
				{
					return v * MILLISECONDS_IN_YEAR;
				}
					
				case "days":
				default:
				{
					return v * MILLISECONDS_IN_DAY;
				}
			}
		}
		
		/**
		 *  @private
		 */
		private var millisecondsP:String;
		
		/**
		 *  @private
		 */
		private var secondsP:String;
		
		/**
		 *  @private
		 */
		private var minutesP:String;
		
		/**
		 *  @private
		 */
		private var hoursP:String;
		
		/**
		 *  @private
		 */
		private var dateP:String;
		
		/**
		 *  @private
		 */
		private var dayP:String;
		
		/**
		 *  @private
		 */
		private var monthP:String;
		
		/**
		 *  @private
		 */
		private var fullYearP:String;
		
		/**
		 *  @private
		 */
		internal static const MILLISECONDS_IN_MINUTE:Number = 1000 * 60;
		
		/**
		 *  @private
		 */
		internal static const MILLISECONDS_IN_HOUR:Number = 1000 * 60 * 60;
		
		/**
		 *  @private
		 */
		internal static const MILLISECONDS_IN_DAY:Number = 1000 * 60 * 60 * 24;
		
		/**
		 *  @private
		 */
		internal static const MILLISECONDS_IN_WEEK:Number = 1000 * 60 * 60 * 24 * 7;
		
		/**
		 *  @private
		 */
		internal static const MILLISECONDS_IN_MONTH:Number = 1000 * 60 * 60 * 24 * 30;
		
		/**
		 *  @private
		 */
		internal static const MILLISECONDS_IN_YEAR:Number = 1000 * 60 * 60 * 24 * 365;
		
		/**
		 */		
		private var UNIT_PROGRESSION:Object =
		{
			milliseconds: null,
			seconds: "milliseconds",
			minutes: "seconds",
			hours: "minutes",
			days: "hours",
			weeks: "days",
			months: "weeks",
			years: "months"
		};

		/**
		 */
		override protected function get type():String
		{
			return AxisBase.DATE_AXIS;
		}
	}
}