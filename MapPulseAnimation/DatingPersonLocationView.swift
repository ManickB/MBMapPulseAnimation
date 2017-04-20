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
    
    @IBOutlet weak var gestureIcon: UIImageView!
    var firstX = CGFloat()
    var firstY = CGFloat()
    var pan = UIPanGestureRecognizer()
    var Tab = UITapGestureRecognizer()
    var PersonimageName = NSString()
    @IBOutlet weak var outletGestureButt: UIButton!
    @IBOutlet weak var locatonTable: UITableView!
    @IBOutlet weak var gestureview: UIView!
    @IBOutlet weak var mapview: MKMapView!


    var PersonArr = NSDictionary()
    var TableArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureview.hidden = true
        
        
        
        
        
        self.MBGestureView.frame = CGRectMake(10,(self.view.frame.size.height - self.view.frame.size.height / 3), self.view.frame.size.width  - 20, self.view.frame.size.height)
        

        
        //UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.6)
        self.MBGestureView.backgroundColor =  UIColor.blackColor()
       
        self.SwipeBUtt.frame = CGRectMake(0, 0, self.MBGestureView.frame.size.width,50)
        self.SwipeBUtt.backgroundColor = UIColor.init(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 0.4)
//
        self.SwipeGestureImage.frame = CGRectMake((self.SwipeBUtt.frame.size.width/2 - 50/2), 0, 50,50)
        self.SwipeGestureImage.image = UIImage.init(named: "up.png")
        self.SwipeBUtt.addSubview(self.SwipeGestureImage)
//
        self.MBtable.frame = CGRectMake(0, self.SwipeBUtt.frame.size.height + 1,self.MBGestureView.frame.size.width,(self.MBGestureView.frame.size.height - self.SwipeBUtt.frame.size.height))
        self.MBGestureView.backgroundColor = UIColor.clearColor()
//
        self.MBGestureView.addSubview(self.SwipeBUtt)
        self.MBGestureView.addSubview(self.MBtable)
        self.view.addSubview(self.MBGestureView)
//        
        self.MBtable.registerNib(UINib.init(nibName: "DatingPersonCell", bundle: nil), forCellReuseIdentifier: "DatingPersonCell")
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
        self.MBtable.separatorColor = UIColor.blackColor()

        let  Namearr = NSArray.init(objects: "Jenna White","Marry Bighton","James","Carrie Mathison","Angelica Malroes","Abbey Root","Harry","Miya","Juily","Amelia")
        let Distancearr =  NSArray.init(objects: "400m away","300m away","500m  away","200m away","400m away","300m away","300m away","100m away","200m away","300m away")
        let Agearr =  NSArray.init(objects: "22","28","25","23","22","24","27","21","20","18")
        let Latarray =  NSArray.init(objects: "27.297306","21.384312"," 20.835470","16.390444","15.905263","24.856621","21.121735"," 11.932860","11.981863","20.280544")
        let Lonarray =  NSArray.init(objects: "82.032623","72.958191","81.719482","81.529472","73.821320","87.777565","70.116203","75.571861","75.670265","78.719131")
        
            for i in 0 ..<  Namearr.count
        {
            let dict = NSMutableDictionary()
            dict.setObject(Namearr.objectAtIndex(i), forKey: "name")
            dict.setObject(Distancearr.objectAtIndex(i), forKey: "distance")
            dict.setObject("nearby", forKey: "listname")
            dict.setObject("\(i).jpeg", forKey: "imagename")
            dict.setObject("I'm a little bit crazy,love to dance , eat & and obviously to meet new people! Feel free to send me invitation, we will probably meet one day or another! ;-)", forKey: "about")
            dict.setObject(Agearr.objectAtIndex(i) as! String,forKey: "age")
            dict.setObject(Latarray.objectAtIndex(i) as! String,forKey: "lat")
            dict.setObject(Lonarray.objectAtIndex(i) as! String,forKey: "lon")
            dict.setObject("",forKey: "selecting")
            TableArr.addObject(dict)
        }
        PersonArr = TableArr.objectAtIndex(0) as! NSDictionary
        
      

        
    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: PersonArr.valueForKey("lat")!.doubleValue, longitude: PersonArr.valueForKey("lon")!.doubleValue)
        let annotation = MKPointAnnotation()
        annotation.title = PersonArr.valueForKey("name") as? String
        annotation.subtitle = PersonArr.valueForKey("distance") as? String
        annotation.coordinate = coordinate
        self.mapview.addAnnotation(annotation)
        PersonimageName = PersonArr.valueForKey("imagename") as! String

   self.MBtable.reloadData()
   }
   
    func mapView(mV: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        var pinView : MKAnnotationView? = nil
        pinView = self.mapview.dequeueReusableAnnotationViewWithIdentifier("currentLocation")
        let defaultPinID = "currentLocation"
        if pinView == nil  {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: defaultPinID)
        }
        pinView!.canShowCallout = true
        
        let pulsev = UIView.init(frame: CGRectMake(((pinView?.frame.size.width)! - 130)/2,((pinView?.frame.size.height)! - 130)/2, 130, 130))
        pulsev.layer.cornerRadius = pulsev.frame.size.height / 2
        pulsev.layer.masksToBounds = true
        pulsev.backgroundColor = UIColor.clearColor()
      
        
        PulseView.frame = CGRectMake((pulsev.frame.size.width - 130)/2,(pulsev.frame.size.height - 130)/2,130,130);
        let annotationImage = UIView.init(frame: CGRectMake(((pulsev.frame.size.width) - 50)/2,((pulsev.frame.size.height) - 50)/2, 50, 50))
        annotationImage.backgroundColor = UIColor.init(patternImage: UIImage.init(named:"redpin.png")!)
        let imageView = UIImageView.init(frame: CGRectMake(13,8, 25, 25))
        imageView.layer.masksToBounds = true
        imageView.image = UIImage.init(named: PersonimageName as String)
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        annotationImage.addSubview(imageView)
        pulsev.addSubview(PulseView)
        pulsev.addSubview(annotationImage)
        pinView?.addSubview(pulsev)
        PulseView.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        

        PulseView.colors = [(UIColor.redColor().CGColor as AnyObject), (UIColor.blackColor().CGColor as AnyObject), (UIColor.orangeColor().CGColor as AnyObject)]

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
    func HandleTab(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(self.view.superview!)
//        print("\(location.x)")
//        print("\(location.y)")
        self.actofGesture(self)
    }
    func move(sender: AnyObject) {
        self.view.bringSubviewToFront((sender as! UIPanGestureRecognizer).view!)
        var translatedPoint = (sender as! UIPanGestureRecognizer).translationInView(self.view)
        if (sender as! UIPanGestureRecognizer).state == .Began {
            firstX = sender.view.center.x
            firstY = sender.view.center.y
        }
        translatedPoint = CGPointMake(firstX, firstY + translatedPoint.y)
        sender.view.center = translatedPoint
        if (sender as! UIPanGestureRecognizer).state == .Ended {
            let velocityX: CGFloat = (0.2 * (sender as! UIPanGestureRecognizer).velocityInView(self.view).x)
            let finalX: CGFloat = firstX
            var finalY: CGFloat = translatedPoint.y + (0.35 * (sender as! UIPanGestureRecognizer).velocityInView(self.view).y)
            print("x:\(translatedPoint.x)")
            print("y:\(translatedPoint.y)")
            
            let  UPHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) + 300
            let  DownHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) - 20
            
            print("UPHeight:\(UPHeight)")
            print("DownHeight:\(DownHeight)")
            
            //888
            //504
            
            if translatedPoint.y < UPHeight {
                finalY = DownHeight
                gestureIcon.image = UIImage.init(named: "down")
            }
            else if translatedPoint.y > DownHeight {
                finalY = UPHeight;
                gestureIcon.image = UIImage.init(named: "up")
            }
            let animationDuration: CGFloat = (abs(velocityX) * 0.0002) + 0.2
            print("finalX = \(finalX) , finalY = \(finalY)")
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(NSTimeInterval(animationDuration))
            UIView.setAnimationCurve(.EaseOut)
            UIView.setAnimationDelegate(self)
//            UIView.setAnimationDidStopSelector(#selector(self.animationDidFinish))
            sender.view.center = CGPointMake(finalX, finalY)
            UIView.commitAnimations()
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   

    @IBAction func actofGesture(sender: AnyObject)
    {
        var finalY: CGFloat
        let finalX: CGFloat = self.MBGestureView.center.x
        print("\(self.MBGestureView.center.y)")
        let  UPHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) + 300
        let  DownHeight = (self.view.frame.size.height - self.view.frame.size.height / 3) - 20

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
        UIView.setAnimationDuration(NSTimeInterval( 0.4))
        UIView.setAnimationCurve(.EaseOut)
        UIView.setAnimationDelegate(self)
        //        UIView.setAnimationDidStopSelector( #selector(self.animationDidFinish))
        self.MBGestureView.center = CGPointMake(finalX, finalY)
        UIView.commitAnimations()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return TableArr.count;
      
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("DatingPersonCell") as! DatingPersonCell
        cell.Profileimage.setImageWithURL(NSURL(string:"")!, placeholderImage: UIImage(named:TableArr[indexPath.row].valueForKey("imagename")as! String))

        cell.name.text = TableArr[indexPath.row].valueForKey("name")as? String
        cell.distanceLbl.text = TableArr[indexPath.row].valueForKey("distance")as? String
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let allAnnotations = self.mapview.annotations
        self.mapview.removeAnnotations(allAnnotations)
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: TableArr[indexPath.row].valueForKey("lat")!.doubleValue, longitude: TableArr[indexPath.row].valueForKey("lon")!.doubleValue)
        let annotation = MKPointAnnotation()
        annotation.title = TableArr[indexPath.row].valueForKey("name") as? String
        annotation.subtitle = TableArr[indexPath.row].valueForKey("distance") as? String
        annotation.coordinate = coordinate
        self.mapview.addAnnotation(annotation)
        PersonimageName = TableArr[indexPath.row].valueForKey("imagename") as! String
        self.actofGesture(self)
 
}

}

