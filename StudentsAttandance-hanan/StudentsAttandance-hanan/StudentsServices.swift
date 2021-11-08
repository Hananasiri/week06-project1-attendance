//
//  StudentsServices.swift
//  StudentsAttandance-hanan
//
//  Created by  HANAN ASIRI on 03/04/1443 AH.
//

import Foundation
import UIKit
import FirebaseFirestore


class StudentsService {
    static let shared = StudentsService()
    
    let studentsCollection = Firestore.firestore().collection("students")
    
    func addStudent(student: Student){
        studentsCollection.document(student.id).setData([
            
            "name":student.name,
            "id": student.id,
        ])
    }
    
    
    func deleteStudent(studentId: String) {
        studentsCollection.document(studentId).delete()
    }
    

    func listenToStudents(completion: @escaping (([Student]) -> Void)) {
        studentsCollection.addSnapshotListener { snapshot, error in
            if error != nil {
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            var students: Array<Student> = []
            for document in documents {
                let data = document.data()
                let student = Student(
                    name: (data["name"] as? String) ?? "No NAME",
                    id: (data["id"] as? String) ?? "No ID"
                )
                students.append(student)
            }
            completion(students)
        }
    }
    
    func listenToStudentCount(completion: @escaping ((Int) -> Void)) {
        listenToStudents { students in
            completion(students.count)
        }
    }
}