/**
 * ...
 * XMLParser, versión AS3
 * Parseador de un fichero XML.
 * Segun la aplicacion en cuestion, se utiliza para convertir un fichero XML de configuracion, en objetos contenedores de datos (VOs)
 * 
 * @author Ernesto Pino Martínez
 * @date 12/09/2010
 */

package com.epinom.btob.utils
{
	import com.epinom.btob.data.AuthorVO;
	import com.epinom.btob.data.CaseVO;
	import com.epinom.btob.data.ClientVO;
	import com.epinom.btob.data.ComponentVO;
	import com.epinom.btob.data.DataEventObject;
	import com.epinom.btob.data.ExperiencesVO;
	import com.epinom.btob.data.GreatButtonVO;
	import com.epinom.btob.data.GreatVO;
	import com.epinom.btob.data.ItemGalleryVO;
	import com.epinom.btob.data.ItemSocialVO;
	import com.epinom.btob.data.LinkVO;
	import com.epinom.btob.data.OwnerVO;
	import com.epinom.btob.data.ResolutionVO;
	import com.epinom.btob.data.SectionVO;
	import com.epinom.btob.data.SettingsVO;
	import com.epinom.btob.data.SharingVO;
	import com.epinom.btob.data.SocialVO;
	import com.epinom.btob.data.SoundVO;
	import com.epinom.btob.managers.TableDataManager;
	import com.epinom.btob.ui.ExperiencesSectionController;
	
	import flashx.textLayout.formats.FormatValue;

	public class XMLParser
	{
		public function XMLParser() {}
		
		public static function parseSettingsXML(settingsXML:XML, currentSettings:SettingsVO = null):SettingsVO
		{
			trace("**************************** XMLParser->parseSettingsXML()");
			
			// Instanciando objeto de datos para configuracion
			var settings:SettingsVO = currentSettings ? currentSettings : new SettingsVO();
			
			// Almacenando valores obtenidos del fichero de configuracion
			settings.appName = String(settingsXML.appName);
			settings.version = String(settingsXML.version);	
			
			// Creando objeto de datos y almacenando valores
			var author:AuthorVO = new AuthorVO();
			author.name = String(settingsXML.author.name);
			author.lastname = String(settingsXML.author.lastname);
			author.alias = String(settingsXML.author.alias);
			author.email = String(settingsXML.author.email);
			author.web = String(settingsXML.author.web);
			
			// Asignando objeto de datos al objeto de configuracion principal
			settings.author = author;
			
			// Creando objeto de datos y almacenando valores
			var owner:OwnerVO = new OwnerVO();
			owner.name = String(settingsXML.author.name);
			owner.web = String(settingsXML.author.web);
			
			// Asignando objeto de datos al objeto de configuracion principal
			settings.owner = owner;
			
			// Creando objeto de datos y almacenando valores
			var resolution:ResolutionVO = new ResolutionVO();
			resolution.width = Number(settingsXML.resolution.@width);
			resolution.height = Number(settingsXML.resolution.@height);
			
			// Asignando objeto de datos al objeto de configuracion principal
			settings.resolution = resolution;
			
			// Recorriendo seciones en fichero de configuracion y contruyendo objetos de datos 
			var soundXMLList:XMLList = settingsXML.sounds;
			for each(var sound:XML in soundXMLList.elements())
			{
				// Creando objeto de datos y almacenando valores
				var soundVO:SoundVO = new SoundVO();
				soundVO.id = uint(sound.@id);
				soundVO.url = String(sound.@url);
				
				// Adicionando objeto de datos a la lista de secciones del objeto de configuracion principal
				settings.soundList.push(soundVO);
			}
			
			// Recorriendo seciones en fichero de configuracion y contruyendo objetos de datos 
			var sectionXMLList:XMLList = settingsXML.sections;
			for each(var s:XML in sectionXMLList.elements())
			{
				// Creando objeto de datos y almacenando valores
				var section:SectionVO = new SectionVO();
				section.id = uint(s.@id);
				section.name = String(s.@name);
				section.urlSWF = String(s.@urlSWF);
				section.urlImage = String(s.@urlImage);
				
				// Adicionando objeto de datos a la lista de secciones del objeto de configuracion principal
				settings.sectionVOList.push(section);
			}

			// Recorriendo componentes en fichero de configuracion y contruyendo objetos de datos 
			var componentXMLList:XMLList = settingsXML.components;
			for each(var c:XML in componentXMLList.elements())
			{
				// Creando objeto de datos y almacenando valores
				var component:ComponentVO = new ComponentVO();
				component.type = String(c.type);
				component.className = String(c.className);
				component.instanceName = String(c.instanceName);
				component.visible = StringUtils.stringToBoolean(c.visible);
				component.hashId = String(c.hashId);
				component.url = String(c.url);
				component.changeSize = StringUtils.stringToBoolean(c.changeSize);
				component.percentageWidth = Number(c.percentageWidth);
				component.percentageHeight = Number(c.percentageHeight);
				component.changePositionX = StringUtils.stringToBoolean(c.changePositionX);
				component.changePositionY = StringUtils.stringToBoolean(c.changePositionY);
				component.percentageX = Number(c.percentageX);
				component.percentageY = Number(c.percentageY);
				component.centralReference = StringUtils.stringToBoolean(c.centralReference);
				component.elementOrder = Number(c.elementOrder);
				component.yPosition = Number(c.yPosition);
				component.percentagePadding= StringUtils.stringToBoolean(c.percentagePadding);
				component.paddingTop = Number(c.paddingTop);
				component.paddingBottom = Number(c.paddingBootom);
				component.paddingLeft = Number(c.paddingLeft);
				component.paddingRight = Number(c.paddingRight);
				
				// Adicionando objeto de datos a la lista de componentes del objeto de configuracion principal
				settings.componentVOList.push(component);
			}
			
			return settings;	
		}
		
		public static function parseGreatXML(greatXML:XML):Array
		{
			trace("**************************** XMLParser->parseGreatXML()");
			
			// Inicializando lista de destacados
			var greatList:Array = new Array();
			
			// Recorriendo seciones en fichero de configuracion y contruyendo objetos de datos 
			var greatXMLList:XMLList = greatXML.greats;
			for each(var g:XML in greatXMLList.elements())
			{
				// Creando objeto de datos y almacenando valores
				var great:GreatVO = new GreatVO();
				great.id = uint(g.@id);
				great.clientRef = String(g.clientRef);
				great.caseRef = String(g.caseRef);
				great.urlPost = String(g.urlPost);
				great.client = String(g.client);
				great.urlImage = String(g.urlImage);
				great.urlThumb = String(g.urlThumb);
				great.typeThumb = String(g.urlThumb.@type);
				great.title = String(g.title);
				great.titleTextColor = String(g.title.@textColor);
				great.titleHTMLText = StringUtils.stringToBoolean(g.title.@htmlText);
				great.subtitle = String(g.subtitle);
				great.subtitleTextColor = String(g.subtitle.@textColor);
				great.subtitleHTMLText = StringUtils.stringToBoolean(g.subtitle.@htmlText);
				great.text = String(g.text);
				great.textTextColor = String(g.text.@textColor);
				great.textHTMLText = StringUtils.stringToBoolean(g.text.@htmlText);
				
				// Creando objetos de datos relativos a los botones del destacado
				var caseGreatButtonVO:GreatButtonVO = new GreatButtonVO();
				caseGreatButtonVO.id = String(g.caseButton.@id);				
				caseGreatButtonVO.textColor = String(g.caseButton.@textColor);
				caseGreatButtonVO.htmlText = StringUtils.stringToBoolean(g.caseButton.@htmlText);
				caseGreatButtonVO.text = String(g.caseButton);
				
				var postGreatButtonVO:GreatButtonVO = new GreatButtonVO();
				postGreatButtonVO.id = String(g.postButton.@id);				
				postGreatButtonVO.textColor = String(g.postButton.@textColor);
				postGreatButtonVO.htmlText = StringUtils.stringToBoolean(g.postButton.@htmlText);
				postGreatButtonVO.text = String(g.postButton);
				
				// Adicionando botones al greatVO
				great.caseGreatButton = caseGreatButtonVO;
				great.postGreatButton = postGreatButtonVO;
				
				// Recorriendo secciones en fichero de configuracion y contruyendo objetos de datos 
				var socialXMLList:XMLList = g.social;
				for each(var s:XML in socialXMLList.elements())
				{
					// Creando objeto de datos (SocialVO)
					var social:SocialVO = new SocialVO();
					social.id = uint(s.@id);
					social.name = String(s.name);					
					social.text = String(s.text);				
					social.url = String(s.url);	
					
					// Adicionando objeto de datos a la lista de elementos sociales
					great.socialVOList.push(social);
					
				}
				
				// Adicionando objeto de datos a la lista de destacados
				greatList.push(great);
			}
			
			return greatList;
		}
		
		
		public static function parseExperiencesXML(experiencesXML:XML):ExperiencesVO
		{
			trace("**************************** XMLParser->parseExperiencesXML()");
			
			// Creando objeto de datos (ExperiencesVO)
			var experiencesVO:ExperiencesVO = new ExperiencesVO();
			
			// Recorriendo secciones en fichero de configuracion y contruyendo objetos de datos 
			var clientXMLList:XMLList = experiencesXML.clients;
			for each(var c:XML in clientXMLList.elements())
			{
				// Creando objeto de datos (ClientVO)
				var clientVO:ClientVO = new ClientVO();
				clientVO.id = uint(c.@id);
				clientVO.ref = String(c.ref);
				clientVO.name = String(c.name);
				clientVO.urlLogo = String(c.urlLogo);
				clientVO.urlClient = String(c.urlClient);
				clientVO.title = String(c.title);
				clientVO.urlImage = String(c.urlImage);
				
				// Recorriendo secciones en fichero de configuracion y contruyendo objetos de datos 
				var socialXMLList:XMLList = c.social;
				for each(var s:XML in socialXMLList.elements())
				{
					// Creando objeto de datos (SocialVO)
					var social:SocialVO = new SocialVO();
					social.id = uint(s.@id);
					social.name = String(s.name);					
					social.text = String(s.text);
					social.url = String(s.url);	
					
					// Adicionando objeto de datos a la lista de elementos sociales
					clientVO.socialList.push(social);
					
				}
				
				// Recorriendo secciones en fichero de configuracion y contruyendo objetos de datos 
				var caseXMLList:XMLList = c.cases;
				for each(var p:XML in caseXMLList.elements())
				{
					// Creando objeto de datos (ProjectVO)
					var caseVO:CaseVO = new CaseVO();
					caseVO.id = uint(p.@id);
					caseVO.ref = String(p.ref);
					caseVO.name = String(p.name);
					caseVO.title = String(p.title);
					caseVO.summary = String(p.summary);
					caseVO.description = String(p.description);
					caseVO.typeThumb = String(p.urlThumb.@type);
					caseVO.urlThumb = String(p.urlThumb);
					caseVO.urlPost = String(p.urlPost);
					caseVO.isGreat = StringUtils.stringToBoolean(p.great);
					
					// Recorriendo secciones en fichero de configuracion y contruyendo objetos de datos 
					var servicesXMLList:XMLList = p.services;
					for each(var e:XML in servicesXMLList.elements())
					{
						// Creando objeto de datos (ItemProjectGalleryVO)
						var serviceID:String = new String(e);
						
						// Adicionando item a galleria dentro de un proyecto
						caseVO.serviceList.push(serviceID);
						
						// Creando objeto de datos para adicionarlo a la lista por servicio
						var serviceData:Object = new Object();
						serviceData.clientID = clientVO.id;
						serviceData.caseID = caseVO.id; 
						serviceData.caseName = caseVO.name; 
						
						// En dependencia del nombre del servicio se adiciona a una lista u otra
						switch(serviceID)
						{
							case TableDataManager.SMO_SERVICE:
								ExperiencesSectionController.getInstance().smoService.caseList.push(serviceData);
								break;
							
							case TableDataManager.AUDIOVISUAL_PRODUCTION_SERVICE:
								ExperiencesSectionController.getInstance().audiovisualProductionService.caseList.push(serviceData);
								break;
							
							case TableDataManager.BRAND_ENTERTEINMENT_SERVICE:
								ExperiencesSectionController.getInstance().brandEnterteinmentService.caseList.push(serviceData);
								break;
							
							case TableDataManager.INTERACTIVES_EXPERIENCES_SERVICE:
								ExperiencesSectionController.getInstance().interactivesExperiencesService.caseList.push(serviceData);
								break;
							
							case TableDataManager.PLATFORMS_SERVICE:
								ExperiencesSectionController.getInstance().platformsService.caseList.push(serviceData);
								break;
							
							case TableDataManager.APPS_SERVICE:
								ExperiencesSectionController.getInstance().appsService.caseList.push(serviceData);
								break;
							
							default:
								throw new Error("Nombre de servicio desconocido: " + serviceID);
						}
					}
					
					// Configurando referencia interna en BBDD, si ha sido votado y el rating del caso					
					caseVO.isVoted = StringUtils.stringToBoolean(p.voted);
					caseVO.rating = uint(p.rating);
					
					// Creando objeto de datos adicionar a la lista de los casos mas populares
					var rateObject:Object = new Object();
					rateObject.clientID = clientVO.id;
					rateObject.caseID = caseVO.id; 
					rateObject.clientName = clientVO.name; 
					rateObject.caseName = caseVO.name; 
					rateObject.rating = caseVO.rating;
					rateObject.urlThumb = caseVO.urlThumb;
					ExperiencesSectionController.getInstance().rateObjectList.push(rateObject);
					trace("[CASE DATA] : clientID=" + clientVO.id  + ", caseID=" + caseVO.id + ", clientName=" + clientVO.name + ", caseName=" + caseVO.name + ", rating=" + caseVO.rating);
					
					// Creando objeto de datos (DataEventObject)
					var dataEO:DataEventObject = new DataEventObject();
					dataEO.destination = String(p.destination);
					dataEO.subdestination = String(p.subdestination);
					dataEO.action = String(p.action);
					
					// Adicionando DataEventObject al proyecto
					caseVO.dataEventObject = dataEO;
					
					// Recorriendo secciones en fichero de configuracion y contruyendo objetos de datos 
					var linksXMLList:XMLList = p.links;
					for each(var l:XML in linksXMLList.elements())
					{
						// Creando objeto de datos (ItemProjectGalleryVO)
						var link:LinkVO = new LinkVO();
						link.id = uint(l.@id);
						link.text = String(l.text);						
						link.url = String(l.url);
						
						// Adicionando item a galleria dentro de un proyecto
						caseVO.linkList.push(link);
					}
					
					// Recorriendo secciones en fichero de configuracion y contruyendo objetos de datos 
					var galleryXMLList:XMLList = p.gallery;
					for each(var i:XML in galleryXMLList.elements())
					{
						// Creando objeto de datos (ItemProjectGalleryVO)
						var itemGalleryVO:ItemGalleryVO = new ItemGalleryVO();
						itemGalleryVO.id = uint(i.@id);
						itemGalleryVO.type = String(i.@type);
						itemGalleryVO.thumb = String(i.thumb);
						itemGalleryVO.url = String(i.url);
						
						// Adicionando item a galleria dentro de un proyecto
						caseVO.gallery.push(itemGalleryVO);
					}
					
					// Adicionando proyecto a la lista de proyectos de un cliente
					clientVO.caseList.push(caseVO);
				}
				
				// Adicionando cliente a la lista de clientes de un objeto de datos de tipo ExperiencesVO
				experiencesVO.clientList.push(clientVO);							
			}
			
			trace("Length de la lista de ranking en XMLParser: " + ExperiencesSectionController.getInstance().rateObjectList.length);
			return experiencesVO;
		}
		
		public static function parseSharingXML(sharingXML:XML):SharingVO
		{
			trace("**************************** XMLParser->parseSharingXML()");
			
			// Creando objeto de datos (SharingVo)
			var sharingVO:SharingVO = new SharingVO();
			
			// Recorriendo secciones en fichero de configuracion y contruyendo objetos de datos 
			var facebookXMLList:XMLList = sharingXML.facebook;
			for each(var f:XML in facebookXMLList.elements())
			{
				// Creando objeto de datos (ClientVO)
				var itemFacebook:ItemSocialVO = new ItemSocialVO();
				itemFacebook.id = uint(f.@id);
				itemFacebook.date = String(f.date);
				itemFacebook.dateTextColor = String(f.date.@textColor);
				itemFacebook.dateHTMLText = StringUtils.stringToBoolean(f.date.@htmlText);
				itemFacebook.text = String(f.text);
				itemFacebook.textTextColor = String(f.text.@textColor);
				itemFacebook.textHTMLText = StringUtils.stringToBoolean(f.text.@htmlText);
				itemFacebook.url = String(f.url);	
				
				// Adicionando item a la lista post de facebook
				sharingVO.facebookItemList.push(itemFacebook);
			}
			
			// URL video del ultimo video de YouTube del canal de Btob
			sharingVO.youtubeVideoURL = String(sharingXML.youTube.url);
			
			// Recorriendo secciones en fichero de configuracion y contruyendo objetos de datos 
			var blogXMLList:XMLList = sharingXML.blog;
			for each(var b:XML in blogXMLList.elements())
			{
				// Creando objeto de datos (ClientVO)
				var itemBlog:ItemSocialVO = new ItemSocialVO();
				itemBlog.id = uint(b.@id);
				itemBlog.date = String(b.date);
				itemBlog.dateTextColor = String(b.date.@textColor);
				itemBlog.dateHTMLText = StringUtils.stringToBoolean(b.date.@htmlText);
				itemBlog.text = String(b.text);
				itemBlog.textTextColor = String(b.text.@textColor);
				itemBlog.textHTMLText = StringUtils.stringToBoolean(b.text.@htmlText);
				itemBlog.url = String(b.url);	
				
				// Adicionando item a la lista post de blog
				sharingVO.blogItemList.push(itemBlog);
			}
			
			// Recorriendo secciones en fichero de configuracion y contruyendo objetos de datos 
			var twitterXMLList:XMLList = sharingXML.twitter;
			for each(var t:XML in twitterXMLList.elements())
			{
				// Creando objeto de datos (ClientVO)
				var itemTwitter:ItemSocialVO = new ItemSocialVO();
				itemTwitter.id = uint(t.@id);
				itemTwitter.date = String(t.date);
				itemTwitter.dateTextColor = String(t.date.@textColor);
				itemTwitter.dateHTMLText = StringUtils.stringToBoolean(t.date.@htmlText);
				itemTwitter.text = String(t.text);
				itemTwitter.textTextColor = String(t.text.@textColor);
				itemTwitter.textHTMLText = StringUtils.stringToBoolean(t.text.@htmlText);
				itemTwitter.url = String(t.url);	
				
				// Adicionando item a la lista post de twitter
				sharingVO.twitterItemList.push(itemTwitter);
			}
			
			return sharingVO;
		}
		
	}
}