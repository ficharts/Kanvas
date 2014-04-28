package util
{
	import com.kvs.utils.XMLConfigKit.StyleManager;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	
	import model.vo.ElementVO;
	import model.vo.TextVO;
	
	
	/**
	 * 
	 * 根据样式ID， 初始化VO样式
	 * 
	 * @author wallenMac
	 * 
	 */
	public class StyleUtil
	{
		public function StyleUtil()
		{
		}
		
		/**
		 * 根据元素的局部样式ID, 获取样式定义，同步至元件上;
		 * 
		 * 先应用样式模板，然后再应用颜色，因为有些元素除了样式模板外还有自定义颜色
		 */		
		public static function applyStyleToElement(elementVO:ElementVO, styleID:String = null):void
		{
			// 元件未设置样式ID，采用预设样式ID
			if (styleID)
				elementVO.styleID = styleID;
			
			// 刷新样式构成元素
			elementVO.style = null;
			
			// 有些元素是没有样式定义的，例如图片
			if (elementVO.styleID && elementVO.styleID != 'null')// 数据导入时，没有id的会自动填充为null
			{
				var xml:Object = XMLVOMapper.getStyleXMLBy_ID(elementVO.styleID, elementVO.styleType);
				var colorIndex:uint = elementVO.colorIndex;
				
				if (xml)
					XMLVOMapper.fuck(xml, elementVO);
				
				//如果文本采用了自定义颜色，则不随样式模版
				if (elementVO is TextVO)
				{
					if ((elementVO as TextVO).isCustomColor)
					{
						elementVO.colorIndex = colorIndex;
					}
				}
			}
			
			//根据颜色序号从模板中匹配颜色
			getColor(elementVO);
		}
		
		/**
		 * 根据元素的类型和
		 */		
		public static function getColor(elementVO:ElementVO):void
		{
			var xml:XML = XMLVOMapper.getStyleXMLBy_ID(elementVO.styleType, 'colors') as XML;
			
			if (xml)// 有些特殊的图形是没有颜色定义特性的，其视觉效果是唯一的，仅来自与样式模板，不存在颜色自定义
			{
				var color:Object = StyleManager.setColor(xml.children()[elementVO.colorIndex].toString());
				elementVO.color = color;
			}
			
		}
	}
}