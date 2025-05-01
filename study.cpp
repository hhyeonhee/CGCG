#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <memory>
#include <exception>

using namespace std;

// 1. C언어 struct vs C++ struct/class 예시
struct MyStruct {
    int x;
    void show() const { cout << "x = " << x << endl; }
};

// 2. 클래스 예시 (캡슐화, 생성자/소멸자)
class Dog {
private:
    string name;
public:
    Dog(const string& n) : name(n) {}
    void bark() const { cout << name << " 멍멍!" << endl; }
};

// 3. 참조(reference) 예시
void refExample(int& ref) {
    ref = 20;  // 원본 변수 값이 변경됨
}

// 4. 함수 오버로딩 예시
void print(int x) { cout << "int: " << x << endl; }
void print(double x) { cout << "double: " << x << endl; }

// 5. 템플릿 (제네릭 함수) 예시
template<typename T>
T add(T a, T b) {
    return a + b;
}

// 6. STL 벡터와 람다, 알고리즘 예시
void vectorExample() {
    vector<int> nums = {3, 1, 4, 1, 5};
    sort(nums.begin(), nums.end(), [](int a, int b) { return a < b; });
    for (int n : nums) cout << n << ' ';
    cout << endl;
}

// 7. 스마트 포인터 예시
void smartPointerExample() {
    shared_ptr<Dog> d = make_shared<Dog>("바둑이");
    d->bark();
}

// 8. 람다 함수 예시
void lambdaExample() {
    auto mul = [](int a, int b) { return a * b; };
    cout << "3 * 4 = " << mul(3, 4) << endl;
}

// 9. 예외 처리 예시
void exceptionExample() {
    try {
        throw runtime_error("예외 발생!");
    } catch (const exception& e) {
        cout << "예외 메시지: " << e.what() << endl;
    }
}

int main() {
    cout << "--- MyStruct 예시 ---" << endl;
    MyStruct s{10};
    s.show();

    cout << "--- Dog 예시 ---" << endl;
    Dog d("초코");
    d.bark();

    cout << "--- 참조 예시 ---" << endl;
    int a = 5;
    refExample(a);
    cout << "a = " << a << endl;

    cout << "--- 함수 오버로딩 예시 ---" << endl;
    print(42);
    print(3.14);

    cout << "--- 템플릿 예시 ---" << endl;
    cout << "add<int>(1,2) = " << add<int>(1, 2) << endl;

    cout << "--- STL 벡터 예시 ---" << endl;
    vectorExample();

    cout << "--- 스마트 포인터 예시 ---" << endl;
    smartPointerExample();

    cout << "--- 람다 예시 ---" << endl;
    lambdaExample();

    cout << "--- 예외 처리 예시 ---" << endl;
    exceptionExample();

    return 0;
}
