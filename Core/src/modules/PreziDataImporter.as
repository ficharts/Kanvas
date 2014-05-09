package modules
{
	import model.vo.ElementVO;

	public final class PreziDataImporter
	{
		private static const instance:PreziDataImporter = new PreziDataImporter;
		public function PreziDataImporter()
		{
			if (instance)
				throw new Error("SingleTon");
		}
		
		public static function convertData(xml:XML):XML
		{
			return instance.convertData(xml);
		}
		
		private function convertData(xml:XML):XML
		{
			analyzeInit();
			analyzeCSS (xml.style.toString());
			analyzeObj (xml.descendants("object"));
			analyzePage(xml.descendants("s"));
			return null;
		}
		
		private function analyzeInit(xml:XML):void
		{
			fonts  = {};
			comman = {};
			custom = {};
			data.header.@preziVersion = xml.version;
		}
		
		private function analyzeCSS(data:String):void
		{
			if (data)
			{
				var a:Array = data.split("}");
				var l:uint  = a.length;
				for each (var i:String in a)
				{
					var b:Array  = i.split("{");
					var c:Object = JSON.parse(("{" + b[1] + "}").split(";").join(","));
					var f:String = b[0].substr(0, 1);
					switch (f)
					{
						case "@":
							fonts[c["font-family"]] = c["font-family"];
							break;
						case ".":
							comman[b[0].substr(1)] = c;
							break;
						default:
							custom[b[0]] = c;
							break;
					}
				}
			}
		}
		
		private function analyzeObj(data:XMLList):void
		{
			if (data)
			{
				for each (var xml:XML in data)
				{
					var type:String = (xml.@type == "button") ? xml.type : xml.@type;
					switch (type)
					{
						case "bracket":
						case "roundrect":
						case "invisible":
							createObj(xml, "rect", "Border");
							break;
						case "circle":
							createObj(xml, "circle", "Border");
							break;
						case "shape":
							type = xml.geom.@type;
							switch (type) 
							{
								case "circle":
									createObj(xml, "circle", "Fill");
									break;
								case "line":
									createObj(xml, "line", "Border");
									break;
								case "arrow":
									createObj(xml, "arrowline", "Border");
									break;
								case "poly":
									createObj(xml, (xml.geom.p.length() == 3) ? "triangle" : "rect", "Fill");
									break;
							}
							break;
						case "text":
							createObj(xml, "text", xml["@class"]);
							break;
						case "image":
							createObj(xml, "img", "img");
							break;
						default:
							break;
					}
				}
			}
		}
		
		private function getColor(type:String):String
		{
			var css:Object;
			for (var name:String in comman)
			{
				if (name.indexOf(type) > -1)
				{
					css = comman[name];
					break;
				}
			}
			if (!css)
			{
				for (name in custom)
				{
					if (name.indexOf(type) > -1)
					{
						css = custom[name];
						break;
					}
				}
			}
			if (css)
			{
				if (css.color)
					return css.color;
				else if (css.borderColor)
					return css.borderColor;
				else if (css.gradStartColor)
					return css.gradStartColor;
			}
			
			return "#000000";
		}
		
		private function createObj(data:XML, type:String, style:String, color:String = "000000"):void
		{
			var xml:XML = new XML("<" + type + "/>");
			xml.@id        = data.@id;
			xml.@type      = type;
			xml.@styleID   = style;
			xml.@styleType = style.toLowerCase();
			style = style.toLowerCase();
			
			xml.@x        = data.@x;
			xml.@y        = data.@y;
			xml.@scale    = data.@s;
			xml.@rotation = data.@r;
			xml.@color    = color;
			switch (type)
			{
				case "circle":
					convertCircle(xml, data, style);
					break;
				case "rect":
					convertRect(xml, data, style);
					break;
				case "triangle":
					convertTriangle(xml, data, style);
					break;
				case "line":
					convertLine(xml, data, style);
					break;
				case "arrowline":
					convertArrowline(xml, data, style);
					break;
				case "text":
					convertText(xml, data, style);
					break;
				case "img":
					convertImage(xml, data, style);
					break;
			}
		}
		
		private function convertCircle(target:XML, source:XML, style:String):void
		{
			if (style == "border")
			{
				target.@width  = source.size.w;
				target.@height = source.size.h;
			}
			else if (style == "fill")
			{
				target.@width  = 2 * Number(source.geom.r);
				target.@height = target.@width;
			}
			else
			{
				throw new Error("Unsupport circle Style!");
			}
		}
		
		private function convertRect(target:XML, source:XML, style:String):void
		{
			if (style == "border")
			{
				target.@width  = source.size.w;
				target.@height = source.size.h;
			}
			else if (style == "fill")
			{
				target.@width  = Math.abs(source.geom.p[1].x) * 2;
				target.@height = Math.abs(source.geom.p[1].y) * 2;
			}
			else
			{
				throw new Error("Unsupport rect Style!");
			}
		}
		
		private function convertTriangle(target:XML, source:XML, style:String):void
		{
			if (style == "fill")
			{
				target.@width  = Math.abs(source.geom.p[1].x) * 2;
				target.@height = Math.abs(source.geom.p[1].y) * 2;
				target.@radius = source.geom.r.toString();
			}
			else
			{
				throw new Error("Unsupport rect Style!");
			}
		}
		
		private function convertLine(target:XML, source:XML, style:String):void
		{
			if (style == "border")
			{
				target.@width     = Math.abs(source.geom.sp.toString().split(" ")[0]) * 2;
				target.@height    = 12;
				target.@thickness = source.geom.t;
				if (source.geom.b)
					target.@arc = source.geom.b;
			}
			else
			{
				throw new Error("Unsupport rect Style!");
			}
		}
		
		private function convertArrowline(target:XML, source:XML, style:String):void
		{
			if (style == "border")
			{
				target.@width     = Math.abs(source.geom.sp.toString().split(" ")[0]) * 2;
				target.@height    = 12;
				target.@thickness = source.geom.t;
				if (source.geom.b)
					target.@arc = source.geom.b;
			}
			else
			{
				throw new Error("Unsupport rect Style!");
			}
		}
		
		private function convertText(target:XML, source:XML, style:String):void
		{
			target.@width  = source.width;
			target.@height = source.height;
			var t:XMLList = source.p;
			var s:String = "";
			for each (var x:XML in t)
				s += x.toString() + "\n";
			s.substr(-1);
			target.text = "<![CDATA["+ s +"]]>";
		}
		
		private function convertImage(target:XML, source:XML, style:String):void
		{
			target.@url = source.resource.url;
		}
		
		private function analyzePage(data:XMLList):void
		{
			if (data)
			{
				for each (var xml:XML in data)
				{
					
				}
			}
		}
		
		private var fonts :Object;
		private var comman:Object;
		private var custom:Object;
		
		private var countImage:uint;
		
		private var vos:Vector.<ElementVO>;
		
		private var data:XML = 
		<kanvas>
			<header version = {CoreApp.VER} styleID='style_1'/>
			<main/>
		</kanvas>;
	}
}