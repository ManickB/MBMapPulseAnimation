//
//  DatingPersonLocationView.swift
//  MeetMe
//
//  Created by ViVID on 3/30/17.
//  Copyright © 2017 ViVID. All rights reserved.
//

import UIKit
import MapKit


class DatingPersonLocationView: UIViewController,MKMapViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource
{
    let PulseView = MMPulseView()
    let MBGestureView = UIView()
    let MBtable = UITableView()
    let SwipeBUtt = UIButton()
    let SwipeGestureImage = UIImageView()
    var coordinate = CLLocationCoordinate2D()
    @IBOutlet weak var gestureIcon: UIImageView!
    var firstX = CGFloat()
    var firstY = CGFloat()
    var pan = UIPanGestureRecognizer()
    var Tab = UITapGestureRecognizer()
    var PersonimageName = NSString()
    @IBOutlet weak var mapview: MKMapView!


    var PersonArr = NSDictionary()
    var TableArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mapview.delegate = self
        
        self.MBGestureView.frame = CGRect(x: 10,y: (self.view.frame.size.height - 114), width: self.view.frame.size.width  - 20, height: self.view.frame.size.height)
        

        self.MBGestureView.backgroundColor =  UIColor.black
       
        self.SwipeBUtt.frame = CGRect(x: 0, y: 0, width: self.MBGestureView.frame.size.width,height: 50)
        self.SwipeBUtt.backgroundColor = UIColor.init(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 0.4)

        self.SwipeGestureImage.frame = CGRect(x: (self.SwipeBUtt.frame.size.width/2 - 50/2), y: 0, width: 50,height: 50)
        self.SwipeGestureImage.image = UIImage.init(named: "up.png")
        self.SwipeBUtt.addSubview(self.SwipeGestureImage)

        self.MBtable.frame = CGRect(x: 0, y: self.SwipeBUtt.frame.size.height + 1,width: self.MBGestureView.frame.size.width,height: (self.MBGestureView.frame.size.height - (self.SwipeBUtt.frame.size.height * 3)))
        self.MBGestureView.backgroundColor = UIColor.clear

        self.MBGestureView.addSubview(self.SwipeBUtt)
        self.MBGestureView.addSubview(self.MBtable)
        self.view.addSubview(self.MBGestureView)
      
        self.MBtable.register(UINib.init(nibName: "DatingPersonCell", bundle: nil), forCellReuseIdentifier: "DatingPersonCell")
        self.MBtable.estimatedRowHeight = 72
        
         self.MBtable.delegate = self
        self.MBtable.dataSource = self
        self.pan.delegate = self
        self.pan = UIPanGestureRecognizer(target: self, action: #selector(self.move))
        self.pan.minimumNumberOfTouches = 1
        self.pan.maximumNumberOfTouches = 1
        self.MBGestureView.addGestureRecognizer(self.pan)
        self.Tab.delegate = self
        self.Tab = UITapGestureRecognizer(target: self, action: #selector(self.HandleTab))
        self.SwipeBUtt.addGestureRecognizer(self.Tab)
        self.MBtable.separatorColor = UIColor.black

        let  Namearr = NSArray.init(objects: "Jenna White","Marry Bighton","James","Carrie Mathison","Angelica Malroes","Abbey Root","Harry","Miya","Juily","Amelia")
        let Distancearr =  NSArray.init(objects: "400m away","300m away","500m  away","200m away","400m away","300m away","300m away","100m away","200m away","300m away")
        let Agearr =  NSArray.init(objects: "22","28","25","23","22","24","27","21","20","18")
        let Latarray =  NSArray.init(objects: "27.297306","21.384312"," 20.835470","16.390444","15.905263","24.856621","21.121735"," 11.932860","11.981863","20.280544")
        let Lonarray =  NSArray.init(objects: "82.032623","72.958191","81.719482","81.529472","73.821320","87.777565","70.116203","75.571861","75.670265","78.719131")
        
            for i in 0 ..<  Namearr.count
        {
            let dict = NSMutableDictionary()
            dict.setObject(Namearr.object(at: i), forKey: "name" as NSCopying)
            dict.setObject(Distancearr.object(at: i), forKey: "distance" as NSCopying)
            dict.setObject("nearby", forKey: "listname" as NSCopying)
            dict.setObject("\(i).jpeg", forKey: "imagename" as NSCopying)
            dict.setObject("I'm a little bit crazy,love to dance , eat & and obviously to meet new people! Feel free to send me invitation, we will probably meet one day or another! ;-)", forKey: "about" as NSCopying)
            dict.setObject(Agearr.object(at: i) as! String,forKey: "age" as NSCopying)
            dict.setObject(Latarray.object(at: i) as! String,forKey: "lat" as NSCopying)
            dict.setObject(Lonarray.object(at: i) as! String,forKey: "lon" as NSCopying)
            dict.setObject("",forKey: "selecting" as NSCopying)
            TableArr.add(dict)
        }
        PersonArr = TableArr.object(at: 0) as! NSDictionary
        coordinate = CLLocationCoordinate2D(latitude: (PersonArr.value(forKey: "lat")! as AnyObject).doubleValue, longitude: (PersonArr.value(forKey: "lon")! as AnyObject).doubleValue)
        let annotation = MKPointAnnotation()
        annotation.title = PersonArr.value(forKey: "name") as? String
        annotation.subtitle = PersonArr.value(forKey: "distance") as? String
        annotation.coordinate = coordinate
        DispatchQueue.main.async {
             self.mapview.addAnnotation(annotation) //Yes!! This method adds the annotations
        }
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapview.setRegion(region, animated: true)

        PersonimageName = PersonArr.value(forKey: "imagename") as! String as NSString

   self.MBtable.reloadData()
   }
   
    func mapView(_ mV: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        // Showing Annotation in MapView
        var pinView : MKAnnotationView? = nil
        pinView = self.mapview.dequeueReusableAnnotationView(withIdentifier: "currentLocation")
        let defaultPinID = "currentLocation"
        if pinView == nil  {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: defaultPinID)
        }
        pinView!.canShowCallout = true
        
        let pulsev = UIView.init(frame: CGRect(x: ((pinView?.frame.size.width)! - 130)/2,y: ((pinView?.frame.size.height)! - 130)/2, width: 130, height: 130))
        pulsev.layer.cornerRadius = pulsev.frame.size.height / 2
        pulsev.layer.masksToBounds = true
        pulsev.backgroundColor = UIColor.clear
      
        
        PulseView.frame = CGRect(x: (pulsev.frame.size.width - 130)/2,y: (pulsev.frame.size.height - 130)/2,width: 130,height: 130);
        let annotationImage = UIView.init(frame: CGRect(x: ((pulsev.frame.size.width) - 50)/2,y: ((pulsev.frame.size.height) - 50)/2, width: 50, height: 50))
        annotationImage.backgroundColor = UIColor.init(patternImage: UIImage.init(named:"redpin.png")!)
        let imageView = UIImageView.init(frame: CGRect(x: 13,y: 8, width: 25, height: 25))
        imageView.layer.masksToBounds = true
        imageView.image = UIImage.init(named: PersonimageName as String)
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        annotationImage.addSubview(imageView)
        pulsev.addSubview(PulseView)
        pulsev.addSubview(annotationImage)
        pinView?.addSubview(pulsev)
        PulseView.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        

        PulseView.colors = [(UIColor.red.cgColor as AnyObject), (UIColor.black.cgColor as AnyObject), (UIColor.orange.cgColor as AnyObject)]

        PulseView.locations = [(0.3), (0.5), (0.7)]

        PulseView.minRadius = 0
        PulseView.maxRadius = 80
        
        PulseView.duration = 5
        PulseView.count = 20
        PulseView.lineWidth = 1.0
        PulseView.startAnimation()

        return pinView!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func HandleTab(_ sender: UITapGestureRecognizer) {

        self.actofGesture(self)
    }
    func move(_ sender: AnyObject) {
        
        // Pan Gesture
        
        self.view.bringSubview(toFront: (sender as! UIPanGestureRecognizer).view!)
        var translatedPoint = (sender as! UIPanGestureRecognizer).translation(in: self.view)
        if (sender as! UIPanGestureRecognizer).state == .began {
            firstX = sender.view.center.x
            firstY = sender.view.center.y
        }
        translatedPoint = CGPoint(x: firstX, y: firstY + translatedPoint.y)
        sender.view.center = translatedPoint
        if (sender as! UIPanGestureRecognizer).state == .ended {
            let velocityX: CGFloat = (0.2 * (sender as! UIPanGestureRecognizer).velocity(in: self.view).x)
            let finalX: CGFloat = firstX
            var finalY: CGFloat = translatedPoint.y + (0.35 * (sender as! UIPanGestureRecognizer).velocity(in: self.view).y)

            
            let screenSize = UIScreen.main.bounds.size
            let height = screenSize.height
            var  UPHeight = CGFloat()
            var  DownHeight = CGFloat()
            if height == 568
            {
               UPHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) + 300
               DownHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) - 20
            }
            else if height == 667
            {
                UPHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) + 378
                DownHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) - 20
            }
            else if height == 736
            {
             UPHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) + 445
            DownHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) - 20
            }


            if translatedPoint.y < UPHeight {
                finalY = DownHeight
                gestureIcon.image = UIImage.init(named: "down")
            }
            else if translatedPoint.y > DownHeight {
                finalY = UPHeight;
                gestureIcon.image = UIImage.init(named: "up")
            }
            let animationDuration: CGFloat = (abs(velocityX) * 0.0002) + 0.2

            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(TimeInterval(animationDuration))
            UIView.setAnimationCurve(.easeOut)
            UIView.setAnimationDelegate(self)

            sender.view.center = CGPoint(x: finalX, y: finalY)
            UIView.commitAnimations()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   

    @IBAction func actofGesture(_ sender: AnyObject)
    {
        
        // Tab Gesture
        
        var finalY: CGFloat
        let finalX: CGFloat = self.MBGestureView.center.x
        var  UPHeight = CGFloat()
        var  DownHeight = CGFloat()
        let screenSize = UIScreen.main.bounds.size
        let height = screenSize.height
        if height == 568
        {
            UPHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) + 400
            DownHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) - 20
        }
        else if height == 667
        {
            UPHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) + 478
            DownHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) - 20
        }
        else if height == 736
        {
            UPHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) + 545
            DownHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) - 20
        }


        if self.MBGestureView
            .center.y >= UPHeight {
            finalY = DownHeight
            SwipeGestureImage.image = UIImage.init(named: "down.png")
        }
        else {
            finalY = UPHeight
            SwipeGestureImage.image = UIImage.init(named: "up.png")
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(TimeInterval( 0.4))
        UIView.setAnimationCurve(.easeOut)
        UIView.setAnimationDelegate(self)
        //        UIView.setAnimationDidStopSelector( #selector(self.animationDidFinish))
        self.MBGestureView.center = CGPoint(x: finalX, y: finalY)
        UIView.commitAnimations()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return TableArr.count;
      
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Loading Content in tableview
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatingPersonCell") as! DatingPersonCell
        
        let dict : NSDictionary = TableArr[indexPath.row] as! NSDictionary
        let str : NSString = dict.value(forKey:"imagename") as! NSString
        cell.Profileimage.setImageWith(NSURL.init(string: "") as! URL, placeholderImage: UIImage.init(named: str as String))
        cell.name.text = dict.value(forKey: "name") as? String
        cell.distanceLbl.text = dict.value(forKey: "distance")as? String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let allAnnotations = self.mapview.annotations
        self.mapview.removeAnnotations(allAnnotations)
        let dic : NSDictionary = TableArr[indexPath.row] as! NSDictionary
        coordinate = CLLocationCoordinate2D(latitude: (dic.value(forKey: "lat")! as AnyObject).doubleValue, longitude: (dic.value(forKey: "lon")! as AnyObject).doubleValue)
        let annotation = MKPointAnnotation()
        annotation.title = (TableArr[indexPath.row] as AnyObject).value(forKey: "name") as? String
        annotation.subtitle = (TableArr[indexPath.row] as AnyObject).value(forKey: "distance") as? String
        annotation.coordinate = coordinate
        DispatchQueue.main.async {
        self.mapview.addAnnotation(annotation)
        }
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.mapview.setRegion(region, animated: true)
        PersonimageName = dic.value(forKey: "imagename") as! NSString
        self.actofGesture(self)
 
}

}

