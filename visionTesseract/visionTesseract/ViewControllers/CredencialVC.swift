//
//  CredencialVC.swift
//  visionTesseract
//
//  Created by HP501865 on 05/03/18.
//  Copyright © 2018 HP501865. All rights reserved.
//

import UIKit

class CredencialVC: UIViewController {
    
    //MARK: VARIABLES
    let screenSize = UIScreen.main.bounds.size
    var originY:CGFloat!
    var originX:CGFloat!
    
    //MARK:OUTLETS
    var viewContainer: UIView!
    
    var tvNombre:UITextView!
    var tvDireccion:UITextView!
    
    var tfCveElector:UITextField!
    var tfCURP:UITextField!
    var tfFolio:UITextField!
    var tfAñoRegistro:UITextField!
    var tfEstado:UITextField!
    var tfMunicipio:UITextField!
    var tfSeccion:UITextField!
    var tfLocalidad:UITextField!
    var tfEmision:UITextField!
    var tfVigencia:UITextField!
    var tfFechaNac:UITextField!
    var tfSexo:UITextField!
    var tfEdad:UITextField!
   
    var lblNombre:UILabel!
    var lblDireccion:UILabel!
    var lblFolio:UILabel!
    var lblCveElector:UILabel!
    var lblCURP:UILabel!
    var lblAñoRegistro:UILabel!
    var lblEstado:UILabel!
    var lblMunicipio:UILabel!
    var lblSeccion:UILabel!
    var lblLocalidad:UILabel!
    var lblEmision:UILabel!
    var lblVigencia:UILabel!
    var lblFechaNac:UILabel!
    var lblSexo:UILabel!
    var lblINE:UILabel!
    var lblRegistro:UILabel!
    var lblCredencial:UILabel!
    var lblEdad:UILabel!
    
    var imgEscudo:UIImageView!
    var imgPersona:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        drawUI()
    }

    func drawUI(){
        originY = 50
        
        viewContainer = UIView(frame: CGRect(x: screenSize.width/2 - (screenSize.width * 0.85)/2 ,
                                             y:screenSize.height/2 - (screenSize.height * 0.85)/2,
                                             width:screenSize.width * 0.85,
                                             height:screenSize.height * 0.85))
        viewContainer.backgroundColor = UIColor.white
        self.view.addSubview(viewContainer)
        
        
        imgEscudo = UIImageView(frame: CGRect(x: 20,
                                              y:10,
                                              width: screenSize.width * 0.1,
                                              height: screenSize.width * 0.1))
        imgEscudo.image = #imageLiteral(resourceName: "escudo")
        imgEscudo.backgroundColor = UIColor.white
        self.viewContainer.addSubview(imgEscudo)
        originX = imgEscudo.frame.origin.x + imgEscudo.frame.width
        
        lblINE = UILabel(frame: CGRect(x: originX + 20,
                                       y:imgEscudo.frame.origin.y,
                                       width: screenSize.width * 0.7,
                                       height: screenSize.height * 0.06))
        lblINE.text = "INSTITUTO FEDERAL ELECTORAL"
        lblINE.font = UIFont.boldSystemFont(ofSize: 20)
        lblINE.textColor = UIColor.black
        self.viewContainer.addSubview(lblINE)
        originY = lblINE.frame.origin.y + lblINE.frame.height
        
        lblRegistro = UILabel(frame: CGRect(x: lblINE.frame.origin.x,
                                           y:originY,
                                           width: screenSize.width * 0.7,
                                           height: lblINE.frame.height))
        lblRegistro.text = "REGISTRO FEDERAL DE ELECTORES"
        lblRegistro.font = UIFont.boldSystemFont(ofSize: 16)
        lblRegistro.textColor = UIColor.black
        self.viewContainer.addSubview(lblRegistro)
        originY = lblRegistro.frame.origin.y + lblRegistro.frame.height
        
        lblCredencial = UILabel(frame: CGRect(x: lblINE.frame.origin.x,
                                            y:originY,
                                            width: screenSize.width * 0.7,
                                            height: lblINE.frame.height))
        lblCredencial.text = "CREDENCIAL PARA VOTAR"
        lblCredencial.font = UIFont.boldSystemFont(ofSize: 14)
        lblCredencial.textColor = UIColor.black
        self.viewContainer.addSubview(lblCredencial)
        originY = lblCredencial.frame.origin.y + lblCredencial.frame.height
        
        lblNombre = UILabel(frame: CGRect(x: 20,
                                         y:originY,
                                         width: screenSize.width * 0.1,
                                         height: screenSize.height * 0.07))
        lblNombre.text = "NOMBRE"
        lblNombre.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblNombre)
        originY = lblNombre.frame.origin.y + lblNombre.frame.height
        
        tvNombre = UITextView(frame: CGRect(x: 15,
                                        y:originY - 13,
                                        width: screenSize.width * 0.15,
                                        height: screenSize.height * 0.2))
        tvNombre.text = "CORTEZ \nGARCIA \nSAUL ALBERTO"
        tvNombre.font = UIFont.boldSystemFont(ofSize: 12)
        tvNombre.backgroundColor = UIColor.clear
        tvNombre.textColor = UIColor.black
        self.viewContainer.addSubview(tvNombre)
        
        lblEdad = UILabel(frame: CGRect(x: screenSize.width/2,
                                        y:tvNombre.frame.origin.y - 5,
                                        width: lblNombre.frame.width,
                                        height: lblNombre.frame.height))
        lblEdad.text = "EDAD"
        lblEdad.backgroundColor = UIColor.clear
        lblEdad.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblEdad)
        
        tfEdad = UITextField(frame: CGRect(x: (lblEdad.frame.origin.x + lblEdad.frame.height) + 5,
                                      y:lblEdad.frame.origin.y,
                                      width: screenSize.width * 0.03,
                                      height: lblNombre.frame.height))
        tfEdad.text = "18"
        tfEdad.font = UIFont.boldSystemFont(ofSize: 12)
        tfEdad.backgroundColor = UIColor.clear
        self.viewContainer.addSubview(tfEdad)
        originY = lblEdad.frame.origin.y + lblEdad.frame.height
        
        lblSexo = UILabel(frame: CGRect(x: screenSize.width/2,
                                        y:originY - 10,
                                        width: lblNombre.frame.width,
                                        height: lblNombre.frame.height))
        lblSexo.text = "SEXO"
        lblSexo.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblSexo)
        
        
        tfSexo = UITextField(frame: CGRect(x: (lblSexo.frame.origin.x + lblSexo.frame.height) + 5,
                                           y:lblSexo.frame.origin.y,
                                           width: tfEdad.frame.width,
                                           height: lblNombre.frame.height))
        tfSexo.text = "H"
        tfSexo.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfSexo)
        originX = tfSexo.frame.origin.x + tfSexo.frame.width
        
        imgPersona = UIImageView(frame: CGRect(x: originX + 10,
                                               y:lblEdad.frame.origin.y,
                                               width: screenSize.width * 0.25,
                                               height: screenSize.height * 0.6))
        imgPersona.backgroundColor = UIColor.lightGray
        self.viewContainer.addSubview(imgPersona)
        originY = tvNombre.frame.origin.y + tvNombre.frame.height
        
        lblDireccion = UILabel(frame: CGRect(x:lblNombre.frame.origin.x,
                                             y:originY - 15,
                                             width: lblNombre.frame.width,
                                             height: lblNombre.frame.height))
        lblDireccion.text = "DIRECCION"
        lblDireccion.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblDireccion)
        originY = lblDireccion.frame.origin.y + lblDireccion.frame.height
        
        tvDireccion = UITextView(frame: CGRect(x: 15,
                                            y:originY - 13,
                                            width: screenSize.width * 0.4,
                                            height: screenSize.height * 0.15))
        tvDireccion.text = "PRIV LAS CRUCES 7 BIS\nPBLO SAN JUANICO NEXTIPAC 09400\nIZTAPALAPA ,D.F."
        tvDireccion.font = UIFont.boldSystemFont(ofSize: 12)
        tvDireccion.backgroundColor = UIColor.clear
        tvDireccion.textColor = UIColor.black
        self.viewContainer.addSubview(tvDireccion)
        originY = tvDireccion.frame.origin.y + tvDireccion.frame.height
        
        lblFolio = UILabel(frame: CGRect(x:lblNombre.frame.origin.x,
                                        y:originY - 10,
                                        width: screenSize.width * 0.05,
                                        height: lblNombre.frame.height))
        lblFolio.text = "FOLIO"
        lblFolio.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblFolio)
        originX = lblFolio.frame.origin.x + lblFolio.frame.width
        
        tfFolio = UITextField(frame: CGRect(x:originX + 5,
                                       y:lblFolio.frame.origin.y + 1,
                                       width: screenSize.width * 0.15,
                                       height: lblNombre.frame.height))
        tfFolio.text = "1309202123571"
        tfFolio.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfFolio)
        originX = tfFolio.frame.origin.x + tfFolio.frame.width
        
        lblAñoRegistro = UILabel(frame: CGRect(x:originX + 10,
                                               y:lblFolio.frame.origin.y,
                                               width: screenSize.width * 0.15,
                                               height: lblNombre.frame.height))
        lblAñoRegistro.text = "AÑO DE REGISTRO"
        lblAñoRegistro.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblAñoRegistro)
        originX = lblAñoRegistro.frame.origin.x + lblAñoRegistro.frame.width
        
        tfAñoRegistro = UITextField(frame: CGRect(x:originX,
                                            y:tfFolio.frame.origin.y,
                                            width: screenSize.width * 0.15,
                                            height: lblNombre.frame.height))
        tfAñoRegistro.text = "2013    00"
        tfAñoRegistro.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfAñoRegistro)
        originY = lblFolio.frame.origin.y + lblFolio.frame.height
        
        lblCveElector = UILabel(frame: CGRect(x:lblNombre.frame.origin.x,
                                              y:originY - 10,
                                              width: screenSize.width * 0.2,
                                              height: lblNombre.frame.height))
        lblCveElector.text = "CLAVE DE ELECTOR"
        lblCveElector.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblCveElector)
        originX = lblCveElector.frame.origin.x + lblCveElector.frame.width
        
        tfCveElector = UITextField(frame: CGRect(x:originX - 15,
                                                  y:lblCveElector.frame.origin.y + 1,
                                                  width: screenSize.width * 0.25,
                                                  height: lblNombre.frame.height))
        tfCveElector.text = "CRGRSL95080909H300"
        tfCveElector.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfCveElector)
        originY = lblCveElector.frame.origin.y + lblCveElector.frame.height
        
        lblCURP = UILabel(frame: CGRect(x:lblNombre.frame.origin.x,
                                        y:originY - 10,
                                        width: screenSize.width * 0.05,
                                        height: lblNombre.frame.height))
        lblCURP.text = "CURP"
        lblCURP.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblCURP)
        originX = lblCURP.frame.origin.x + lblCURP.frame.width
        
        tfCURP = UITextField(frame: CGRect(x:originX ,
                                                 y:lblCURP.frame.origin.y + 1,
                                                 width: screenSize.width * 0.25,
                                                 height: lblNombre.frame.height))
        tfCURP.text = "COGS950809HDFARRL06"
        tfCURP.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfCURP)
        originY = lblCURP.frame.origin.y + lblCURP.frame.height
        
        lblEstado = UILabel(frame: CGRect(x:lblNombre.frame.origin.x,
                                          y:originY - 10,
                                          width: screenSize.width * 0.1,
                                          height: lblNombre.frame.height))
        lblEstado.text = "ESTADO"
        lblEstado.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblEstado)
        originX = lblEstado.frame.origin.x + lblEstado.frame.width
        
        tfEstado = UITextField(frame: CGRect(x:originX - 10 ,
                                            y:lblEstado.frame.origin.y + 1,
                                            width: screenSize.width * 0.05,
                                            height: lblNombre.frame.height))
        tfEstado.text = "09"
        tfEstado.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfEstado)
        originX = tfEstado.frame.origin.x + tfEstado.frame.width
        
        lblMunicipio = UILabel(frame: CGRect(x:originX,
                                             y:lblEstado.frame.origin.y,
                                             width: screenSize.width * 0.1,
                                             height: lblNombre.frame.height))
        lblMunicipio.text = "MUNICIPIO"
        lblMunicipio.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblMunicipio)
        originX = lblMunicipio.frame.origin.x + lblMunicipio.frame.width

        tfMunicipio = UITextField(frame: CGRect(x:originX - 10 ,
                                             y:lblEstado.frame.origin.y + 1,
                                             width: screenSize.width * 0.05,
                                             height: lblNombre.frame.height))
        tfMunicipio.text = "09"
        tfMunicipio.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfMunicipio)
        originY = lblEstado.frame.origin.y + lblEstado.frame.height
        
        lblLocalidad = UILabel(frame: CGRect(x:lblNombre.frame.origin.x,
                                             y:originY - 10,
                                             width: screenSize.width * 0.1,
                                             height: lblNombre.frame.height))
        lblLocalidad.text = "LOCALIDAD"
        lblLocalidad.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblLocalidad)
        originX = lblLocalidad.frame.origin.x + lblLocalidad.frame.width
        
        tfLocalidad = UITextField(frame: CGRect(x:originX ,
                                                y:lblLocalidad.frame.origin.y ,
                                                width: screenSize.width * 0.05,
                                                height: lblNombre.frame.height))
        tfLocalidad.text = "0001"
        tfLocalidad.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfLocalidad)
        originX = tfLocalidad.frame.origin.x + tfLocalidad.frame.width
        
        lblSeccion = UILabel(frame: CGRect(x:originX + 10,
                                             y:lblLocalidad.frame.origin.y,
                                             width: screenSize.width * 0.1,
                                             height: lblNombre.frame.height))
        lblSeccion.text = "SECCION"
        lblSeccion.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblSeccion)
        originX = lblSeccion.frame.origin.x + lblSeccion.frame.width
        
        tfSeccion = UITextField(frame: CGRect(x:originX - 10 ,
                                                y:lblSeccion.frame.origin.y,
                                                width: screenSize.width * 0.05,
                                                height: lblNombre.frame.height))
        tfSeccion.text = "2413"
        tfSeccion.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfSeccion)
        originY = lblLocalidad.frame.origin.y + lblLocalidad.frame.height
        
        
        lblEmision = UILabel(frame: CGRect(x:lblNombre.frame.origin.x,
                                             y:originY - 10,
                                             width: screenSize.width * 0.1,
                                             height: lblNombre.frame.height))
        lblEmision.text = "EMISION"
        lblEmision.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblEmision)
        originX = lblEmision.frame.origin.x + lblEmision.frame.width
        
        tfEmision = UITextField(frame: CGRect(x:originX ,
                                                y:lblEmision.frame.origin.y ,
                                                width: screenSize.width * 0.05,
                                                height: lblNombre.frame.height))
        tfEmision.text = "2013"
        tfEmision.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfEmision)
        originX = tfEmision.frame.origin.x + tfEmision.frame.width
        
        lblVigencia = UILabel(frame: CGRect(x:originX + 10,
                                           y:lblEmision.frame.origin.y,
                                           width: screenSize.width * 0.1,
                                           height: lblNombre.frame.height))
        lblVigencia.text = "VIGENCIA"
        lblVigencia.font = UIFont.boldSystemFont(ofSize: 10)
        self.viewContainer.addSubview(lblVigencia)
        originX = lblVigencia.frame.origin.x + lblVigencia.frame.width
        
        tfVigencia = UITextField(frame: CGRect(x:originX - 10 ,
                                              y:lblVigencia.frame.origin.y,
                                              width: screenSize.width * 0.05,
                                              height: lblNombre.frame.height))
        tfVigencia.text = "2023"
        tfVigencia.font = UIFont.boldSystemFont(ofSize: 12)
        self.viewContainer.addSubview(tfVigencia)
        
    }
    
    func drawUI2(){
        
    }
}
