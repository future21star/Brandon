function getIndex(id, list, object=true) {
    id = parseInt(id);
    var  len = list.length;
    for (var i = 0; i < len; i++) {
        var t = list[i];
        var tid = object ? t.id : parseInt(t);
        if (tid === id) {
            // console.log("found index: " + i + " for id: " + id)
            return i;
        }
    }
    // console.log("faild to find a matching id for: " + id + " in: " + JSON.stringify(list))
}

function getValueAtIndex(id, list, object=true) {
    var index = getIndex(id, list, object);
    return list[index].name;
}

function isEmpty(obj) {
    if (obj != null) {
        for (var prop in obj) {
            if (obj.hasOwnProperty(prop))
                return false;
        }
    }
    return true;
}

function sleep (time) {
    return new Promise((resolve) => setTimeout(resolve, time));
}

function countyToProvinceList(country, instances) {
    var countryProvinceMap = instances[[0]];
    var keys = Object.keys(countryProvinceMap);
    var index = getIndex(country, keys, false);
    return countryProvinceMap[keys[index]];
}

Number.prototype.clamp = function(min, max) {
    return Math.min(Math.max(this, min), max);
};

function getFormLabel(isRequired, props) {
    return props.label && isRequired ? props.label+ '*' : props.label;
}

function getClassNameBasedOnValidation(isValid, showRequired, props) {
    // Set a specific className based on the validation
    // state of this component. showRequired() is true
    // when the value is empty and the required prop is
    // passed to the input. showError() is true when the
    // value typed is invalid
    var className = 'form-group ';
    if (!isValid) {
        className += 'error';
    } else if (showRequired) {
        className += 'required';
    }
    if (props.hidden) {
        className += " hidden";
    }
    return className;
}

function onAjaxError(xhr) {
    var json = xhr.responseJSON;
    var state = null;
    switch(xhr.status) {
        case 400:
            console.log("400ing");
            json = {base: ['Missing required fields (*)']};
            state = {errors: json, captcha: '', forceScroll: true};
            break;
        case 401:
            console.log("Session expired");
            // FIXME: Pop up login modal...this will apply to authed forms using this template
            break;
        case 404:
            console.log("404ing");
            window.location.href = "/404";
            break;
        case 422:
            console.log("Validation failed");
            state = {errors: json, captcha: '', forceScroll: true};
            break;
        case 500:
            console.log("shit fucked up");
            window.location.href = "/500";
            break;
    }
    return state;
}

function renderErrors(state) {
    var errors = [];
    var message = '';
    if (state.errors) {
        const base_errors = state.errors['base'];
        // console.log("base_errors " + JSON.stringify(base_errors));
        if (base_errors && base_errors.length > 0) {
            const len = base_errors.length;
            message = <h2>
                Errors prohibited the form from being saved
            </h2>;
            for (var i = 0; i < len; i++) {
                const error = base_errors[i];
                errors.push(
                    <li key={i}>{error}</li>
                );
            }
        }
    }
    return (
        <Element name={ERRORS_NAME} className="errors">
            {message}
            <ul>
                {errors}
            </ul>
        </Element>
    );
}