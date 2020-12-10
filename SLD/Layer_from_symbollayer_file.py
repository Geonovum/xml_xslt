import PyQt5.QtCore
import qgis.gui
import math
import numpy as np

polygon = QPolygonF()

#Square
#polygon = QPolygonF( QRectF( QPointF( -1, -1 ), QPointF( 1, 1 ) ) )
#QuarterSquare
#polygon = QPolygonF( QRectF( QPointF( -1, -1 ), QPointF( 0, 0 ) ) )
#HalfSquare
#polygon = QPolygonF( QRectF( QPointF( -1, -1 ), QPointF( 0, 1 ) ) )
#DiagonalHalfSquare
"""
polygon << QPointF( -1, -1 ) 
polygon << QPointF( 1, 1 ) 
polygon << QPointF( -1, 1 ) 
polygon << QPointF( -1, -1 )
"""
#Diamond
#"""
polygon << QPointF( -1, 0 ) 
polygon << QPointF( 0, 1 )
polygon << QPointF( 1, 0 ) 
polygon << QPointF( 0, -1 ) 
polygon << QPointF( -1, 0 )
#"""
#Pentagon
"""
polygon << QPointF( -0.9511, -0.3090 )
polygon << QPointF( -0.5878, 0.8090 )
polygon << QPointF( 0.5878, 0.8090 )
polygon << QPointF( 0.9511, -0.3090 )
polygon << QPointF( 0, -1 )
polygon << QPointF( -0.9511, -0.3090 )
"""
#Hexagon
"""
polygon << QPointF( -0.8660, -0.5 )
polygon << QPointF( -0.8660, 0.5 )
polygon << QPointF( 0, 1 )
polygon << QPointF( 0.8660, 0.5 )
polygon << QPointF( 0.8660, -0.5 )
polygon << QPointF( 0, -1 )
polygon << QPointF( -0.8660, -0.5 )
"""
#Triangle
"""
polygon << QPointF( -1, 1 ) 
polygon << QPointF( 1, 1 ) 
polygon << QPointF( 0, -1 ) 
polygon << QPointF( -1, 1 )
"""
#EquilateralTriangle
"""
polygon << QPointF( -0.8660, 0.5 ) 
polygon << QPointF( 0.8660, 0.5 ) 
polygon << QPointF( 0, -1 ) 
polygon << QPointF( -0.8660, 0.5 )
"""
#LeftHalfTriangle
"""
polygon << QPointF( 0, 1 ) 
polygon << QPointF( 1, 1 ) 
polygon << QPointF( 0, -1 ) 
polygon << QPointF( 0, 1 )
"""
#RightHalfTriangle
"""
polygon << QPointF( -1, 1 ) 
polygon << QPointF( 0, 1 ) 
polygon << QPointF( 0, -1 ) 
polygon << QPointF( -1, 1 )
"""
#Star
"""
inner_r = math.cos( np.deg2rad( 72.0 ) ) / math.cos( np.deg2rad( 36.0 ) );

polygon << QPointF( inner_r * math.sin( np.deg2rad( 324.0 ) ), - inner_r * math.cos( np.deg2rad( 324.0 ) ) )  # 324
polygon << QPointF( math.sin( np.deg2rad( 288.0 ) ), - math.cos( np.deg2rad( 288 ) ) )    # 288
polygon << QPointF( inner_r * math.sin( np.deg2rad( 252.0 ) ), - inner_r * math.cos( np.deg2rad( 252.0 ) ) )   # 252
polygon << QPointF( math.sin( np.deg2rad( 216.0 ) ), - math.cos( np.deg2rad( 216.0 ) ) )   # 216
polygon << QPointF( 0, inner_r )         # 180
polygon << QPointF( math.sin( np.deg2rad( 144.0 ) ), - math.cos( np.deg2rad( 144.0 ) ) )   # 144
polygon << QPointF( inner_r * math.sin( np.deg2rad( 108.0 ) ), - inner_r * math.cos( np.deg2rad( 108.0 ) ) )   # 108
polygon << QPointF( math.sin( np.deg2rad( 72.0 ) ), - math.cos( np.deg2rad( 72.0 ) ) )    #  72
polygon << QPointF( inner_r * math.sin( np.deg2rad( 36.0 ) ), - inner_r * math.cos( np.deg2rad( 36.0 ) ) )   #  36
polygon << QPointF( 0, -1 )
polygon << QPointF( inner_r * math.sin( np.deg2rad( 324.0 ) ), - inner_r * math.cos( np.deg2rad( 324.0 ) ) );  # 324
"""
#Arrow
"""
polygon << QPointF( 0, -1 )
polygon << QPointF( 0.5,  -0.5 )
polygon << QPointF( 0.25, -0.5 )
polygon << QPointF( 0.25,  1 )
polygon << QPointF( -0.25,  1 )
polygon << QPointF( -0.25, -0.5 )
polygon << QPointF( -0.5,  -0.5 )
polygon << QPointF( 0, -1 )
"""
#ArrowHeadFilled
"""
polygon << QPointF( 0, 0 ) << QPointF( -1, 1 ) << QPointF( -1, -1 ) << QPointF( 0, 0 )
"""
#CrossFill
"""
polygon << QPointF( -1, -0.2 )
polygon << QPointF( -1, -0.2 )
polygon << QPointF( -1, 0.2 )
polygon << QPointF( -0.2, 0.2 )
polygon << QPointF( -0.2, 1 )
polygon << QPointF( 0.2, 1 )
polygon << QPointF( 0.2, 0.2 )
polygon << QPointF( 1, 0.2 )
polygon << QPointF( 1, -0.2 )
polygon << QPointF( 0.2, -0.2 )
polygon << QPointF( 0.2, -1 )
polygon << QPointF( -0.2, -1 )
polygon << QPointF( -0.2, -0.2 )
polygon << QPointF( -1, -0.2 )
"""
#Circle - ?
#"""
painter = QPainter()
painter.setPen(QPen(Qt.green,  8, Qt.SolidLine))
painter.setBrush(QBrush(Qt.red, Qt.SolidPattern))
painter.drawEllipse(40, 40, 400, 400)
#"""

mem_layer = QgsVectorLayer("Polygon?crs=epsg:28992", "temp_layer", "memory")
mem_layer_provider = mem_layer.dataProvider()

QgsProject.instance().addMapLayer(mem_layer)

qgs_polygon = QgsGeometry.fromQPolygonF(polygon)
del(polygon)
feat=QgsFeature()
feat.setGeometry(qgs_polygon)

mem_layer_provider.addFeatures([feat])
mem_layer.updateExtents()
